import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'db.dart';
import 'package:logging/logging.dart';
import 'package:openid_client/openid_client.dart';
import 'session.dart';
import 'generated/fig.pbgrpc.dart';

final _log = Logger('grpc_auth session');

class SessionError implements Exception {
  String message;

  SessionError(this.message);
}

/// Manage user sessions.
///
/// Sessions are stored in an in-memory hashmap. This will be scalable
/// to a moderate number of users (depending on your usage and memory). Say
/// hundreds or perhaps several thousand.
///
/// When creating a [SessionManager] you can provide optional [SessionPlugin]s to
/// create,save,restore and delete the session to persistent
/// storage.

class SessionManager {
  // map of cookies to sessions for cached lookup.
  final Map<String, Session> _sessionCache = {};
  final Duration sessionCachePurgeDuration;
  final Duration sessionDatabasePurgeDuration;

  late Database db;

  static const cookieSize = 16;

  SessionManager(
      {this.sessionCachePurgeDuration = const Duration(days: 1),
      this.sessionDatabasePurgeDuration = const Duration(days: 30),
      required File databaseFile}) {
    Timer.periodic(Duration(seconds: 60), _maintainSessionCache);

    db = Database(databaseFile: databaseFile);
  }

  // Wake up and maintain the session cache and DB
  void _maintainSessionCache(Timer t) async {
    // Loop through the in memory cache
    var now = DateTime.now();
    for (final MapEntry(value: session) in _sessionCache.entries) {
      var purgeTime = now.subtract(sessionCachePurgeDuration);
      if (session.lastAccessTime.isBefore(purgeTime)) {
        await deleteSession(session);
      }
    }
    //
    db.purgeSessionsCreatedBefore(now.subtract(sessionDatabasePurgeDuration));
  }

  /// Get the session based on the unique opaque [cookie].
  /// todo: Do we update the session DB access time?
  Future<Session?> getSession(String cookie) async {
    Session? s = _sessionCache[cookie];
    if (s == null) {
      s = await db.getSession(cookie);
      if (s == null) return null;
      _sessionCache[cookie] = s;
    }
    s.lastAccessTime = DateTime.now();
    return s;
  }

  //  Lookup or create a session based on the OIDC [claims].
  //
  //  This is called from the [AuthService.authenticate{}] method..
  //  The claims are verified before calling this method.
  // Returns a record:  [FigErrorResponse] is non null if the session can not be created
  // or a [Session].
  Future<(FigErrorResponse?, Session?)> createSession({
    required OpenIdClaims claims,
  }) async {
    // _log.finest('Create session with idToken $idToken');

    final cookie = _genRandomString(cookieSize);
    var now = DateTime.now();
    final session = Session(
      cookie: cookie,
      claims: claims,
      createdAt: now,
      lastAccessTime: now,
      subject: claims.subject,
    );
    _sessionCache[cookie] = session;
    try {
      await db.insertSession(session);
      _log.finest('Created session ${session.cookie}');
      return (null, session);
    } catch (e) {
      return (
        FigErrorResponse(
            message: 'error creating session in DB: $e', code: 500),
        null
      );
    }
  }

  // Remove a session from the cache
  Future<void> deleteSession(Session session) async {
    _sessionCache.remove(session.cookie);
    await db.deleteSession(session.cookie);
  }

  final _random = Random.secure();

  String _genRandomString(int len) {
    var values = List<int>.generate(len, (i) => _random.nextInt(255));
    return base64UrlEncode(values);
  }
}
