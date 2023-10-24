import 'package:grpc/grpc.dart';

import 'session.dart';
import 'session_manager.dart';


typedef CreateFN =Future<Context>Function(Session session);
/// Context information needed to evaluate the caller
/// You need to extend this class to add information needed by your application
/// For example, lookup the user in a database, set the user roles, etc.

class Context {
  /// The associated session
  final Session session;
  Context(this.session);
}

/// Extend this...?
class ContextManager {
  final SessionManager sessionManager;
  // the context cache, keyed by the opaque session cookie.
  final Map<String, Context> _cache = {};
  final CreateFN onContextCreate;

  ContextManager({required this.sessionManager, required this.onContextCreate});

  /// In a grpc call, get the context from the cache.
  /// Throws a session error if there is no auth header in the call.
  /// If your grpc method should be unauthenticated, add the method name
  /// when initializing the [AuthService].
  Future<Context> getContext(ServiceCall call) async {
    var cookie = (call.clientMetadata ?? {})['authorization'];
    if (cookie == null) {
      throw SessionError(
          'Session cookie not found. Missing "authorization" "header');
    }

    var ctx = _cache[cookie];
    if (ctx != null) {
      return ctx;
    }
    // No cached context found. We need to create it
    var s = await sessionManager.getSession(cookie);

    if (s == null) {
      throw SessionError(
          'Session not found for authorization cookie. Did the user authenticate?');
    }

    // Create a new context. Call the supplied function to enhance the context
    final c = await onContextCreate(s);
    _cache[s.cookie] = c;
    return c;
  }
}
