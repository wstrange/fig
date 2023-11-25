import 'package:fig_flutter/fig_flutter.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
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

final channel = ClientChannel(hostName,
    port: 50051,
    options: const ChannelOptions(
        connectTimeout: Duration(seconds: 20),
        credentials: ChannelCredentials.insecure()));

/// THe auth client to handle our gRPC authentication calls.
final figClient = FigClient(channel: channel);

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              serverMessage,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      try {
                        var r = await client
                            .hello_no_auth(Hello(message: 'No Auth'));
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
                    child: Text('Hello - no Auth')),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        var r = await client.hello(Hello(message: 'Auth Me!'));
                        setState(() {
                          serverMessage = r.message;
                        });
                      } on Exception catch (e) {
                        setState(() {
                          serverMessage = 'Error: $e';
                        });
                      }
                    },
                    child: Text('Hello - Auth')),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: signedIn
                        ? null
                        : () async {
                            // this will naviagate to the fluter fire UI for
                            // authentication. If successful, the gRPC server
                            // will be called to authenticate. Your server
                            // can return extra data (this is a Map)
                            // for example, loyalty number, etc.
                            var (user, extraData) =
                                await figClient.signInWithFirebase(
                              authProviders: providers,
                              additionalAuthInfo: {'clubNumber' : '1234'},
                              context: context,
                            );
                            // You might want to grab the firebase user data here for your app
                            print(
                                'Firebase user = $user, extra data = $extraData)');
                            setState(() {
                              signedIn = true;
                              serverMessage =
                                  'Signed in! extra server info: $extraData';
                            });
                          },
                    child: Text('Sign in')),
                ElevatedButton(
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
                        : null,
                    child: Text('Sign Out')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
