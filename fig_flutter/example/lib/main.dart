import 'package:fig_flutter/fig_flutter.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'firebase_options.dart';
import 'src/generated/example.pbgrpc.dart';

/// For Firebase Google Auth, you need your google client id.
/// Replace this with the value from your Firebase console.
const googleClientId =
    '465372895035-r5o2hedarih4l5u8297p1b3d7vmk5prs.apps.googleusercontent.com';

/// List of Firebase auth providers. Modify per your Firebase setup
var providers = <AuthProvider>[
  EmailAuthProvider(),
  GoogleProvider(clientId: googleClientId),
];

/// Replace this with the hostname of your gRPC server
const hostName = 'localhost';
// const hostName = 'warrens-air.lan';

// Create a channel supporting both Web and http/2 calls.
final channel = GrpcOrGrpcWebClientChannel.toSeparateEndpoints(
    grpcHost: hostName,
    grpcWebHost: 'localhost',
    grpcPort: 50051,
    grpcWebPort: 9080,
    grpcTransportSecure: false,
    grpcWebTransportSecure: false);

final figClient = FigClient(channel);

/// Initialize our gRPC client. You MUST include the fig interceptor
final client = ExampleClient(channel, interceptors: [figClient.interceptor]);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Fig gRPC demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String serverMessage = '[none]';
  bool signedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Wrap(
              direction: Axis.horizontal,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      try {
                        var r = await client.hello_no_auth(Hello(
                            message: 'Hello from unauthenticated Fig client'));
                        print('response = ${r.message}');
                        setState(() {
                          serverMessage = r.message;
                        });
                      } on Exception catch (e) {
                        /// Error!!
                        setState(() {
                          serverMessage = 'Error: $e ';
                        });
                      }
                    },
                    child: const Text('Say Hello: No Authentication required')),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        var r = await client
                            .hello(Hello(message: 'Hello from Flutter!'));
                        setState(() {
                          serverMessage = r.message;
                        });
                      } on Exception catch (e) {
                        setState(() {
                          serverMessage = 'Error: $e';
                        });
                      }
                    },
                    child: const Text('Say Hello - Auth required')),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                ElevatedButton(
                    // If signed in, show sign out button
                    onPressed: signedIn
                        ? () async {
                            try {
                              await figClient.signOut(context);
                            } on Exception catch (e) {
                              print('Exception signing out: $e');
                            }
                            setState(() {
                              signedIn = false;
                              serverMessage = 'Signed out';
                            });
                          }
                        //else show sign in
                        : () async {
                            // this will naviagate to the fluter fire UI for
                            // authentication. If successful, the gRPC server
                            // will be called to authenticate. Your server
                            // can return extra data (this is a Map)
                            // for example, loyalty number, etc.
                            var user = await figClient.signInWithFirebase(
                              authProviders: providers,
                              context: context,
                            );
                            // You might want to grab the firebase user data here for your app
                            print('Firebase user = $user');
                            setState(() {
                              signedIn = true;
                              serverMessage = 'Signed in';
                            });
                          },
                    child: signedIn
                        ? const Text('Sign Out')
                        : const Text('Sign in')),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Last grpc message received from server:'),
                      const SizedBox(height: 20),
                      SelectableText(
                        serverMessage,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
