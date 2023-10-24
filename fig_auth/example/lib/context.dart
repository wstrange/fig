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


/// An example of extending the Context with additional app specific
/// info.
class AppContext extends Context {
  String? enhanceHelloMessage; // some extra context

  AppContext(super.session, this.enhanceHelloMessage) {
    print('Create Context');
  }

  String toString() =>
      'AppContext claims: ${session.claims} enhanced data" $enhanceHelloMessage';
}

// Context provided to authenticated grpc calls.
final contextMgr = ContextManager(
    sessionManager: sessionManager,
    // Called with a context is created. THis is where you can
    // enhance the context with application specific info needed
    // by your grpc methods.
    // return a Context (or subclass)
    onContextCreate: (session) async {
      return AppContext(session, 'Additional Session Data');
    });

