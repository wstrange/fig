import 'package:fig_auth/fig_auth.dart';
import 'package:openid_client/openid_client.dart';

/// Session plugins are called on session lifecycle events. Create session, etc
/// This simple example mostly delegates to the DefaultSessionPlugin.
/// See [SessionPlugin].
class MySessionPlugins extends DefaultSessionPlugin {
  @override
  Future<(FigErrorResponse, Map<String, dynamic>)> createSession(
      OpenIdClaims claims,
      Map<String, dynamic> additionalAuthDataForDecision) async {
    // nothing to do - pass back some data to the client.
    // This could be data from your database backend, etc.
    return (okResponse, {'foo': 'bar'});
  }
}

final sessionManager = SessionManager(sessionPlugin: MySessionPlugins());

/// This is our application specific context.
/// It extends the standard context (containing OIDC claims) with
/// application specific data.
///
/// For example, you can lookup the user in the database
/// This context is available on server calls.
class AppContext extends Context {
  String? extraGreeting; // some extra context

  AppContext(super.session, {required this.extraGreeting}) {
    print('Create Context');
  }

  String toString() =>
      'AppContext claims: ${session.claims} enhanced data" $extraGreeting';
}

// Context provided to authenticated grpc calls.
final contextMgr = ContextManager(
    sessionManager: sessionManager,
    // Called when a context is created. THis is where you can
    // enhance the context with application specific info needed
    // by your grpc methods.
    // return a Context (or subclass)
    onContextCreate: (session) async {
      return AppContext(session, extraGreeting: 'and a good day to you!');
    });

