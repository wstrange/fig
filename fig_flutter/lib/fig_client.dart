import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'src/generated/fig.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'client_interceptor.dart';

class FigClient {
  final ClientChannel channel;
  final FigAuthServiceClient authClient;

  final interceptor = ClientAuthInterceptor();

  FigClient({required this.channel})
      : authClient = FigAuthServiceClient(channel);

  /// Attempts to Sign in with Firebase. If successful, a Firebase [User] is returned.
  /// If the attempt is not a success, null is returned.
  Future<User?> signInWithFirebase({
    required List<AuthProvider> authProviders,
    required BuildContext context,
    required Future<String?> Function(Map<String, dynamic> authData) onSignIn,
    required Future Function() onSignOut,
    Map<String, dynamic> additionalAuthInfo = const {},
    bool debug = false,
  }) async {
    var completer = Completer<User?>();

    _showToast(BuildContext context, String message) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: 20),
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
                          jsonAuthData: jsonEncode(additionalAuthInfo),
                        ));
                        // print('Server Authentication response = $resp');
                        if (resp.error.code > 200) {
                          _showToast(context,
                              'Could  not authenticate to server $resp');
                          completer.complete(null);
                          return;
                        }
                        // This adds the auth token to every subsequent GRPC request
                        interceptor.sessionToken = resp.sessionToken;

                        // invoke callback to decode any additional info provided by the server
                        // as part of the auth context.
                        // coould be sectionId, sectiosn list, ec.
                        // callback returns non null string on error
                        var errString =
                            await onSignIn(jsonDecode(resp.jsonAuthData));

                        if (errString != null) {
                          _showToast(context, errString);
                          completer.complete(null);
                          return;
                        }
                      } catch (e) {
                        _showToast(context, e.toString());
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

  Future<void> signOut() async {
    await authClient.logoff(LogoffRequest());
    await FirebaseAuth.instance.signOut();
  }
}
