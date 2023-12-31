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
  TextColumn get claims => text().withLength(max: 1024)();

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
    var claims = s.claims.toJson();

    var news = await into(sessionTbl).insertReturning(SessionTblData(
        cookie: s.cookie,
        lastAccessTime: s.lastAccessTime,
        createdAt: s.createdAt,
        claims: jsonEncode(claims)));
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
      claims: claims,
    );
  }

  Future<void> deleteSession(String cookie) async {
    await delete(sessionTbl)
      ..where((t) => t.cookie.equals(cookie))..go();
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
