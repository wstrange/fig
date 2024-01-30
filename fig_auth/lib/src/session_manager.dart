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
/// Sessions are cached in a in-memory hashmap and persisted to
/// a sqlite database. This will be scalable
/// to a moderate number of users (depending on your usage and memory). Say
/// a few thousand.
///
/// Because sessions are persisted to sqllite, restarting the server
/// will retain existing sessions.
///

class SessionManager {
  // map of cookies to sessions for cached lookup.
  final Map<String, Session> _sessionCache = {};
  final Duration sessionCachePurgeDuration;
  final Duration sessionDatabasePurgeDuration;

  late Database db;

  static const cookieSize = 16;

  ///
  /// Create a session manager
  /// [sessionDatabasePurgeDuration] is the duration that sessions
  ///  live for in the in-memory cache.
  ///  [sessionDatabasePurgeDuration] is the duration that session live
  ///  in the persistent sqllite database.
  ///  [databaseFile] is the sqllite database location.
  SessionManager(
      {this.sessionCachePurgeDuration = const Duration(days: 1),
      this.sessionDatabasePurgeDuration = const Duration(days: 30),
      required File databaseFile}) {
    Timer.periodic(Duration(seconds: 600), _maintainSessionCache);

    db = Database(databaseFile: databaseFile);
  }

  // Wake up and maintain the session cache and DB
  void _maintainSessionCache(Timer t) async {
    final now = DateTime.now();
    final purgeTime = now.subtract(sessionCachePurgeDuration);
    _sessionCache.removeWhere((key, session) =>
       session.lastAccessTime.isBefore(purgeTime));

    db.purgeSessionsCreatedBefore(now.subtract(sessionDatabasePurgeDuration));
  }

  /// Get the session based on the unique opaque [cookie].
  /// Looks in the cache first, then the database.
  /// todo: Do we update the session DB access time? Consider a dirty
  /// flag on the Session object, to denote it should be flushed to the DB
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

  //  Create a session based on the OIDC [claims].
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
    final now = DateTime.now();
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
