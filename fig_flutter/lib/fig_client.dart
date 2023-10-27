import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'src/generated/fig.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'client_interceptor.dart';

typedef JsonMap = Map<String, dynamic>;
const JsonMap _emptyMap = {};

class FigClient {
  final ClientChannel channel;
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
  Future<(User?, Map<String, dynamic>)> signInWithFirebase({
    required List<AuthProvider> authProviders,
    required BuildContext context,
    Map<String, dynamic> additionalAuthInfo = const {},
    bool debug = false,
  }) async {
    var completer = Completer<(User?, JsonMap)>();

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
                        completer.complete((null, _emptyMap));
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
                          jsonAuthData: jsonEncode(additionalAuthInfo),
                        ));
                        // print('Server Authentication response = $resp');
                        if (resp.error.code > 200) {
                          _showToast(
                              context, 'Error authenticating to server $resp');
                          completer.complete((null, _emptyMap));
                          return;
                        }
                        // This adds the auth token to every subsequent GRPC request
                        interceptor.sessionToken = resp.sessionToken;

                        var data = jsonDecode(resp.jsonAuthData);
                        if (data is Map) {
                          completer.complete((user, data as JsonMap));
                        } else {
                          completer.complete((user, _emptyMap));
                        }
                      } catch (e) {
                        _showToast(context, e.toString());
                        completer.complete((null, _emptyMap));
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
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      _showToast(context, 'Error on signOut. You can probably ignore this: $e');
    } finally {
      interceptor.authToken = null;
      interceptor.sessionToken = null;
    }
  }
}
