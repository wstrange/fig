import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'db.dart';
import 'session_plugin.dart';
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
  late SessionPlugin plugin;
  // map of cookies to sessions for cached lookup.
  final Map<String, Session> _sessionCache = {};
  final Duration sessionCachePurgeDuration;
  late Database db;

  static final cookieSize = 16;

  SessionManager(
      {SessionPlugin? sessionPlugin,
      this.sessionCachePurgeDuration = const Duration(days: 1),
      required File databaseFile}) {
    // If no sessions plugins are provided, use a default one
    plugin = sessionPlugin ?? DefaultSessionPlugin();
    Timer.periodic(Duration(seconds: 30), _maintainSessionCache);

    db = Database(databaseFile: databaseFile);


  }

  void _maintainSessionCache(Timer t) async {
    for (final MapEntry(value: session) in _sessionCache.entries) {
      var purgeTime = DateTime.now().subtract(sessionCachePurgeDuration);
      if (session.lastAccessTime.isBefore(purgeTime)) {
        _purge(session);
        continue;
      }
      if (session.persisted) continue;
      await plugin.saveSession(session);
      session.persisted = true;
    }
  }

  /// Get the session based on the unique opaque [cookie].
  Future<Session?> getSession(String cookie) async {
    Session? s = _sessionCache[cookie];
    if (s == null) {
      s = await plugin.restoreSession(cookie);
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

    var err= await plugin.createSession(claims);
    if (err.code != 200) {
      return (err, null);
    }

    final cookie = _genRandomString(cookieSize);
    var now = DateTime.now();
    final session = Session(
        cookie: cookie,
        claims: claims,
        createdAt: now,
        lastAccessTime: now,
        );
    _sessionCache[cookie] = session;
    await db.insertSession(session);
    _log.finest('Created session ${session.cookie}');
    return (null, session);
  }

  // Remove a session from the cache
  Future<void> deleteSession(Session session) async {
    _sessionCache.remove(session.cookie);
    await db.deleteSession(session.cookie);
    await plugin.deleteSession(session.cookie);
  }

  final _random = Random.secure();

  String _genRandomString(int len) {
    var values = List<int>.generate(len, (i) => _random.nextInt(255));
    return base64UrlEncode(values);
  }
  //
  // Future<Session> deserializeFromDb(String cookie, String json) async {
  //   var s = jsonDecode(json) as Map<String, dynamic>;
  //   var cookie = s['cookie'] as String;
  //   var claims = OpenIdClaims.fromJson(s['claims'] as Map<String, dynamic>);
  //   var lastAccessTime = DateTime.parse(s['lastAccessTime']);
  //   var createdAt = DateTime.parse(s['createdAt']);
  //
  //   return Session(
  //     cookie: cookie,
  //     claims: claims,
  //     lastAccessTime: lastAccessTime,
  //     createdAt: createdAt,
  //     data: {},
  //   );
  // }

  void _purge(Session session) {
    // remove from cache
    _sessionCache.remove(session.cookie);
    plugin.deleteSession(session.cookie);
  }
}
