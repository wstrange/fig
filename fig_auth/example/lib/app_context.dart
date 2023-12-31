import 'package:fig_auth/fig_auth.dart';

/// This is our application specific context.
/// It extends the standard context (containing OIDC claims) with
/// application specific data.
///
/// For example, you can lookup the user in the database
/// This context is available on server calls.
class AppContext extends Context {
  String? extraGreeting; // some extra context

  AppContext(super.session, {required this.extraGreeting}) {
    print('Create Context');
  }

  String toString() =>
      'AppContext claims: ${session.claims} enhanced data" $extraGreeting';
}
