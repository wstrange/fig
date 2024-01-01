import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_ui_auth/firebase_ui_auth.dart' ;
import 'package:flutter/material.dart';
import 'auth.dart';
import 'src/generated/fig.pbgrpc.dart';
// import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_web.dart';
import 'client_interceptor.dart';

typedef JsonMap = Map<String, dynamic>;
const JsonMap _emptyMap = {};

class FigClient {
  // final ClientChannel channel;
  final GrpcWebClientChannel channel;
  late FigAuthServiceClient _authClient;

  final interceptor = ClientAuthInterceptor();

  FigClient({required this.channel}) {
    _authClient = FigAuthServiceClient(channel, interceptors: [interceptor]);
  }

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

  /// Attempts to Sign in with Firebase. If successful, a Firebase [User] is returned.
  /// If the attempt is not a success, null is returned.
  Future<fb.User?> signInWithFirebase({
    required List<AuthProvider> authProviders,
    required BuildContext context,
    Map<String, String> additionalAuthInfo = const {},
    bool debug = false,
  }) async {
    var completer = Completer<fb.User?>();

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
                            await _authClient.authenticate(AuthenticateRequest(
                          idToken: figAuthInterceptor.authToken,
                          additionalAuthData:additionalAuthInfo,
                        ));
                        // print('Server Authentication response = $resp');
                        if (resp.error.code > 200) {
                          _showToast(
                              context, 'Error authenticating to server $resp');
                          completer.complete(null);
                          return;
                        }
                        // This adds the auth token to every subsequent GRPC request
                        interceptor.sessionToken = resp.sessionToken;

                        completer.complete(user);


                      } catch (e) {
                        _showToast(context, e.toString());
                        completer.complete(null);
                      }
                      return;
                    }),

                    /// Todo: Not clear we need this...
                    SignedOutAction((context) async {
                      //print('signed out action...');
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

  Future<void> signOut(BuildContext context) async {
    try {
      await _authClient.logoff(LogoffRequest());
      await fb.FirebaseAuth.instance.signOut();
    } catch (e) {
      _showToast(context, 'Error on signOut. You can probably ignore this: $e');
    } finally {
      interceptor.authToken = null;
      interceptor.sessionToken = null;
    }
  }
}
