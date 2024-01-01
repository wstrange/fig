import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:openid_client/openid_client.dart';

import '../fig_auth.dart';

part 'db.g.dart';

// The table to persist our sessions
class SessionTbl extends Table {
  TextColumn get cookie => text().withLength(
      min: SessionManager.cookieSize, max: SessionManager.cookieSize)();
  DateTimeColumn get lastAccessTime => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  // OIDC claims as json / jwt
  TextColumn get claims => text().withLength(max: 1024)();

  /// The oidc subject
  /// Note the same subject could be logged in more than once
  /// So this is not a unique column
  TextColumn get subject => text()();

  @override
  Set<Column> get primaryKey => {cookie};
}

@DriftDatabase(tables: [SessionTbl])
class Database extends _$Database {
  // we tell the database where to store the data with this constructor
  Database(
      {required File databaseFile,
      bool logStatements = true,
      bool deleteExistingDb = false})
      : super(_openConnection(databaseFile, logStatements, deleteExistingDb));

  @override
  int get schemaVersion => 1;

  Future<void> insertSession(Session s) async {
    var claims = jsonEncode(s.claims.toJson());

    await into(sessionTbl).insert(SessionTblCompanion.insert(
        cookie: s.cookie,
        lastAccessTime: s.lastAccessTime,
        createdAt: s.createdAt,
        claims: claims,
        subject: s.claims.subject));
  }

  Future<Session?> getSession(String cookie) async {
    var q = select(sessionTbl)..where((t) => t.cookie.equals(cookie));
    var r = await q.getSingleOrNull();
    if (r == null) return null;

    var c = r.toCompanion(true);

    print('companion = $c');

    var claims = OpenIdClaims.fromJson(jsonDecode(c.claims.value));
    print('claims = $claims');
    return Session(
      cookie: cookie,
      createdAt: c.createdAt.value,
      lastAccessTime: c.lastAccessTime.value,
      subject: c.subject.value,
      claims: claims,
    );
  }

  Future<void> deleteSession(String cookie) async {
    delete(sessionTbl)
      ..where((t) => t.cookie.equals(cookie))
      ..go();
  }

  // Delete any sessions created before the date
  Future<void> purgeSessionsCreatedBefore(DateTime date) async {
    delete(sessionTbl)
      ..where((t) => t.createdAt.isSmallerOrEqualValue(date))
      ..go();
  }
}

LazyDatabase _openConnection(File databaseFile,
    [bool logStatements = true, bool deleteExistingDb = false]) {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    if (deleteExistingDb) {
      try {
        print('Deleting database ${databaseFile.path}');
        databaseFile.deleteSync();
      } catch (e) {}
    }

    return NativeDatabase.createInBackground(databaseFile,
        logStatements: logStatements);
  });
}
