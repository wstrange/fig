import 'package:fig_serv_example/logging_interceptor.dart';
import 'package:grpc/grpc.dart';
import 'package:fig_auth/fig_auth.dart';
import 'package:logging/logging.dart';
import 'package:fig_serv_example/fig_serv_example.dart';

// Replace this with your firebase project ID
final firebaseId = 'figexample';

var logger = Logger('fig_auth_example');

void main(List<String> arguments) async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  // MySvc is a our sample grpc service
  final svc = MySvc();

  // AuthService is the required Fig Authentication service.
  final authSvc = AuthService(
      firebaseProjectId: firebaseId,
      sessionManager: sessionManager,
      // A list of grpc methods that will NOT be authenticated.
      unauthenticatedMethodNames: ['hello_no_auth',]);

  // Create service - make sure you include authSvc as well
  // as your own application service.
  final server = Server.create(
    services: [authSvc, svc],
    // you MUST include the authInterceptor
    interceptors: [loggingInterceptor, authSvc.authInterceptor],
    codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
  );

  logger.info('Starting Example Grpc Service');
  await server.serve(port: 50051,);
}
