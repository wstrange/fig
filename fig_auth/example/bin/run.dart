import 'package:fig_serv_example/logging_interceptor.dart';
import 'package:fig_serv_example/my_session_plugin.dart';
import 'package:grpc/grpc.dart';
import 'package:fig_auth/fig_auth.dart';
import 'package:logging/logging.dart';
import 'package:fig_serv_example/fig_serv_example.dart';

/// Sample gRPC service with Firebase authentication.
///
///
///


// Replace this with your firebase project ID
final firebaseId = 'figexample';
final port = 50051;

var logger = Logger('fig_auth_example');

void main(List<String> arguments) async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final sessionManager = SessionManager(sessionPlugin: MySessionPlugins());

// Context provided to authenticated grpc calls.
  final contextMgr = ContextManager(
      sessionManager: sessionManager,
      // Called when a context is created. THis is where you can
      // enhance the context with application specific info needed
      // by your grpc methods.
      // return a Context (or subclass)
      onContextCreate: (session) async {
        return AppContext(session, extraGreeting: 'and a good day to you!');
      });


  // MySvc isyour grpc service
  final svc = MySvc(contextMgr);

  // AuthService is the required Fig Authentication service.
  final authSvc = AuthService(
      firebaseProjectId: firebaseId,
      sessionManager: sessionManager,
      // A list of grpc methods that will NOT be authenticated.
      unauthenticatedMethodNames: ['hello_no_auth',]);

  // Create server - make sure you include authSvc as well
  // as your own application service.
  final server = Server.create(
    services: [authSvc, svc],
    // you MUST include the authInterceptor
    interceptors: [loggingInterceptor, authSvc.authInterceptor],
    codecRegistry: CodecRegistry(codecs: const [GzipCodec(),
      // To support grpc web, remove IdentityCode()
      // See https://github.com/grpc/grpc-dart/issues/506#issuecomment-882058839
      // IdentityCodec()
    ]),
  );

  logger.info('Starting Example Grpc Service on $port');
  await server.serve(port: port,);
}
