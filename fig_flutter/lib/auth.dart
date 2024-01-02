import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'client_interceptor.dart';

import 'src/generated/fig.pbgrpc.dart';

/// Auth interceptor that will inject the session cookie into every grpc call
/// TODO: Move to FicAuthClient impl
final figAuthInterceptor = ClientAuthInterceptor();

/// Attempts to Sign in with Firebase. If successful, a Firebase [User] is returned.
/// If the attempt is not a success, null is returned.
Future<fb.User?> signInWithFirebase({
  required List<AuthProvider> authProviders,
  required BuildContext context,
  // required Future<String?> Function(Map<String, String> authData) onSignIn,
  required Future Function() onSignOut,
  required FigAuthServiceClient authClient,
  Map<String, String> additionalAuthInfo = const {},
  bool debug = false,
}) async {
  var completer = Completer<fb.User?>();

  showToast(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 20),
        ),
      );
    }
  }

  unawaited(
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Builder(
            builder: (context) {
              return SignInScreen(
                providers: authProviders,
                actions: [
                  AuthStateChangeAction<SignedIn>((context, state) async {
                    if (state.user == null) {
                      completer.complete(null);
                      return;
                    }
                    var user = state.user!;

                    try {
                      var idToken = await user.getIdToken();
                      figAuthInterceptor.authToken = idToken;

                      //print('Got auth token from firebase = $idToken');
                      var resp =
                          await authClient.authenticate(AuthenticateRequest(
                        idToken: figAuthInterceptor.authToken,
                        additionalAuthData: {'foo': 'bar'},
                      ));
                      // print('Server Authentication response = $resp');
                      if (resp.error.code > 200) {

                        if(context.mounted) {
                          showToast(
                            context, 'Could  not authenticate to server $resp');
                        }
                        completer.complete(null);
                        return;
                      }
                      // This adds the auth token to every subsequent GRPC request
                      figAuthInterceptor.sessionToken = resp.sessionToken;

                    } catch (e) {
                      if( context.mounted) {
                        showToast(context, e.toString());
                      }
                      completer.complete(null);
                    }
                    completer.complete(user);
                    return;
                  }),
                  /// Todo: Not clear we need this...
                  SignedOutAction((context) async {
                    print('signed out action...');
                    await onSignOut();
                    //ref.read(loggedInProvider.notifier).state = false;
                  }),
                ],
              );
            },
          );
        },
      ),
    ),
  );

  var result = await completer.future;
  if (context.mounted) {
    Navigator.of(context).pop();
  }
  return result;
}
