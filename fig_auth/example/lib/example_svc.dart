import 'src/generated/example.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:logging/logging.dart';
import 'context.dart';

final logger = Logger('mySvc');

// Sample RPC service
class MySvc extends ExampleServiceBase {

  Future<AppContext> getContext(ServiceCall call) async {
    // get the application context...
    // This includes the OIDC claims in hte session,
    // but could be the user info or other app specfic data
    var appContext = await contextMgr.getContext(call) as AppContext;
    logger.info('App Context = $appContext');
    return appContext;
  }

  @override
  Future<HelloResponse> hello(ServiceCall call, Hello request) async {
    logger.info('Hello request = ${request.message}');
    // get the application context...
    // This includes the OIDC claims in hte session,
    // but could be the user info or other app specfic data
    var ctx = await getContext(call);

    return HelloResponse(message: 'Response ${request.message} App extra data =${ctx.enhanceHelloMessage}');
  }

  /// Example that we will put on the no_authenticated list
  @override
  Future<HelloResponse> hello_no_auth(ServiceCall call, Hello request) async {
    // dont call getContext() on unauthenticated calls
    print('Hello no auth = ${request.message}');
    return HelloResponse(message: 'ok');
  }
}
