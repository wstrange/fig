import 'package:openid_client/openid_client.dart';
import 'generated/fig.pbgrpc.dart';
import 'session.dart';

final okResponse = FigErrorResponse(code: 200, message: 'ok');

/// Plugins that are invoked as part of the session life cycle. Override
/// this class with your implementation.
///
/// When creating a [SessionManager] you can override an instance of this class
/// to create,save,restore and delete the session to persistent
/// storage. For example, you can persist a session to a SQL database.
///
/// The default base class is a "no-op". Sessions will only be maintained
/// in the session manager memory cache.
abstract class SessionPlugin {

  const SessionPlugin();
  /// Called as part of session creation lifecycle.
  ///
  /// Check the additional context of the authentication. If session
  /// creation should NOT proceed, return a FigErrorResponse with the
  /// appropriate code.
  ///
  /// Note the OIDC token and claims and have been verified at this stage.
  /// The [additionalAuthDataForDecision] is provided
  /// by contract with the client to make additional authentication
  /// decisions. For example, it could have a member id, or
  /// other data.
  ///
  ///
  /// Returns a record of [FigErrorResponse],[extraDataMap].
  /// If [FigErrorResponse] is not null, there is an auth error
  /// and the session should not be created. Pass that error back to the user.
  ///
  /// [extraData] can contain additional map data passed back to the client
  /// by previous contract. For example, things like membership status.
  ///
  Future<(FigErrorResponse, Map<String,dynamic> extraData)> createSession(
      OpenIdClaims claims, Map<String,dynamic> additionalAuthDataForDecision);

  /// Save a session to persistent storage.
  ///
  /// On success the function should set session.persisted = true.
  Future<void> saveSession(Session session) ;

  /// Function that restores a session from persistent storage.
  Future<Session?> restoreSession(String cookie) ;

  /// Delete a session from persistent storage. [cookie] is the unique
  /// session id.
  Future<void> deleteSession(String cookie) ;
}

/// A default session plugin. This is a no-op,
/// The in-memory hashmap will be used.
class DefaultSessionPlugin implements SessionPlugin {
  @override
  Future<(FigErrorResponse, Map<String, dynamic>)> createSession(OpenIdClaims claims, Map<String, dynamic> additionalAuthDataForDecision) async {
    return (okResponse, <String,dynamic>{});
  }

  @override
  Future<void> deleteSession(String cookie) async {
   return;
  }

  @override
  Future<Session?> restoreSession(String cookie) async {
    return null;
  }

  @override
  Future<void> saveSession(Session session)async {
    return;
  }

}
