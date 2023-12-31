
import 'package:fig_auth/fig_auth.dart';
import 'package:openid_client/openid_client.dart';

/// Session plugins are called on session lifecycle events. Create session, etc
/// This simple example mostly delegates to the DefaultSessionPlugin.
/// See [SessionPlugin].
class MySessionPlugins extends DefaultSessionPlugin {
  @override
  Future<FigErrorResponse> createSession(
      OpenIdClaims claims,) async {
    // nothing to do - pass back some data to the client.
    // This could be data from your database backend, etc.
    return okResponse;
  }
}
