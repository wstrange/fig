import 'dart:convert';

import 'package:grpc/grpc.dart' hide Client;
import 'package:logging/logging.dart';
import 'package:openid_client/openid_client.dart';

import 'session.dart';
import 'session_manager.dart';
import 'generated/fig.pbgrpc.dart';

final _log = Logger('fb_auth_svc');

class AuthService extends FigAuthServiceBase {
  // The firebase project to verify authentication tokens against
  final String firebaseProjectId;
  // Grpc that should *not* be intercepted for authentication.
  // note that the 'authenticate' method provided by this package
  // will never be intercepted.
  final List<String> unauthenticatedMethodNames;
  late SessionManager _sessionManager;

  AuthService({
    required this.firebaseProjectId,
    this.unauthenticatedMethodNames = const [],
    SessionManager? sessionManager,
  }) {
    // create a default memory only session manager if one is not provided
    _sessionManager = sessionManager ?? SessionManager();
  }

  @override
  Future<AuthenticateResponse> authenticate(
      ServiceCall call, AuthenticateRequest request) async {
    try {
      var claims = await verifyFirebaseToken(request.idToken);
      if (claims == null) {
        var msg = 'id token claims can not be verified';
        _log.severe(msg);
        return AuthenticateResponse(
            error: FigErrorResponse(code: 403, message: msg));
      }

      var m = jsonDecode(request.jsonAuthData) as Map<String, dynamic>;

      var (err, session) = await _sessionManager.createSession(
        claims: claims,
        authData: m,
      );

      if (err != null || session == null) {
        return AuthenticateResponse(error: err);
      }

      return AuthenticateResponse(
          sessionToken: session.cookie,
          jsonAuthData: jsonEncode(session.data),
          error: FigErrorResponse(code: 200, message: 'ok'));
    } catch (e) {
      _log.severe('Error while trying to authenticate the user $e');
      return AuthenticateResponse(
          error: FigErrorResponse(code: 403, message: e.toString()));
    }
  }

  // Removes the session, destroys the session cookie
  @override
  Future<FigErrorResponse> logoff(
      ServiceCall call, LogoffRequest request) async {
    try {
      var session = await getSession(call);
      _sessionManager.deleteSession(session!);
    } catch (e) {
      return FigErrorResponse(code: 403, message: e.toString());
    }

    return FigErrorResponse(code: 200);
  }

  // Get the session from the session manager
  // The authorization header provides the session token / cookie for lookup
  // returns a [Session] or null if one does not exist
  // Usage:
  // var fbAuth = AuthService(...);
  // fbAuth.getSession(call);
  Future<Session?> getSession(ServiceCall call) async {
    var cookie = call.clientMetadata!['authorization'] ?? '';
    return await _sessionManager.getSession(cookie);
  }

  // Interceptor to add to your grpc service calls.
  // var fbAuth = AuthService(...)
  // For example:  interceptors: [loggingInterceptor, fBauth.authInterceptor],
  // This interceptor checks the grpc header for a session cookie.
  // If the session cookie is found, and is valid, the call proceeds down
  // the chain (returns null).  If the cookie is not found or is not valid
  // the call fails.
  Future<GrpcError?> authInterceptor(
    ServiceCall call,
    ServiceMethod method,
  ) async {
    //_log.finest('authInterceptor ${call}');

    final metadata = call.clientMetadata ?? {};
    final isUnauthenticated = method.name == 'authenticate' ||
        unauthenticatedMethodNames.contains(method.name);

    _log.finest(
        'authInterceptor ${method.name} metadata: $metadata skipAuth=$isUnauthenticated');

    if (isUnauthenticated) {
      // auth method is unauthenticated
      return null;
    }
    final cookie = metadata['authorization'];

    //print('auth cookie = $cookie');

    if (cookie == null) {
      return GrpcError.unauthenticated('Missing authentication Token');
    }

    // todo: Check the validity of the session here, or wait until getSession?
    var s = await _sessionManager.getSession(cookie);
    if (s == null) {
      return GrpcError.unauthenticated(
          'No session found for authorization cookie');
    }

    return null; // call chain can proceed if there is no error
  }

  Client? _oidcClient;

  Future<OpenIdClaims?> verifyFirebaseToken(String token) async {
    // todo: this needs to be refreshed every X hours via cache control time

    // todo: check for issuer time expired and renew the issuer.
    // This is usually done via an http header on the provider. The
    // library doesnt return this for us?
    if (_oidcClient == null) {
      var issuer = await Issuer.discover(Issuer.firebase(firebaseProjectId));
      _oidcClient = Client(issuer, firebaseProjectId);
      _log.finest('Created Firebase issuer');
    }
    var c = _oidcClient!.createCredential(idToken: token);

    var violations =
        c.validateToken(validateClaims: true, validateExpiry: true);

    var ok = true;
    await for (var v in violations) {
      _log.warning('auth violation $v');
      ok = false;
    }

    //_log.info('Token ok $ok, claims = ${c.idToken.claims}');

    return ok ? c.idToken.claims : null;
  }
}
