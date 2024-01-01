
import 'package:fig_auth/fig_auth.dart';
import 'package:openid_client/openid_client.dart';
import 'package:test/test.dart';
import 'dart:io';

void main() {

  final dbFile = File('/tmp/sessionDb.sql');

  tearDown(() async { await dbFile.delete();});

  test('Session Manager', () async {

    var sm = SessionManager(databaseFile: dbFile);

    var claims = OpenIdClaims.fromJson({'sub': '1234'});

    var (err,session) = await sm.createSession(claims: claims);
    expect(session, isNotNull);

    if( session == null )
      fail('Cant create session $err');

    print(session);

    var s =  await sm.db.getSession(session.cookie);

    if( s == null ) {
      fail('Cant get back session that was just created');
    }

    print(s);

    await sm.deleteSession(s);

    expect( await sm.getSession(s.cookie), isNull);

    // delete it again - should not cause problems
    await sm.deleteSession(s);

  });
}
