import 'package:test/test.dart';
import 'dart:io';

import 'package:fig_auth/src/db.dart';

main() {
  test('db test', () async {
    var f = File('/tmp/db1.sqllite');
    var db = Database(databaseFile: f);

    // get a cookie that does not exist
    var c = await db.getSession('foo');

    expect(c, isNull);

    var now = DateTime.now();

    var cookie = '1234567890123456';
    var v = await db.into(db.sessionTbl).insertReturning(
        SessionTblCompanion.insert(
            cookie: cookie, subject: 'sub123',
            lastAccessTime: now, createdAt: now, claims: '{}'));

    c = await db.getSession(cookie);
    expect(c, isNotNull);

    expect(c!.cookie, equals(cookie));

    print(v);

    await f.delete();
  });
}
