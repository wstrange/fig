import 'src/generated/example.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:logging/logging.dart';
import 'context.dart';

final logger = Logger('mySvc');

// Sample RPC service
class MySvc extends ExampleServiceBase {
  /// Example method to fetch the callers context
  /// Your service methods will call this at the start of each method.
  Future<AppContext> getContext(ServiceCall call) async {
    // get the application context...
    // This includes the OIDC claims in the session,
    // but could be the user info or other app specfic data
    var appContext = await contextMgr.getContext(call) as AppContext;
    logger.info('App Context = $appContext');
    return appContext;
  }

  @override
  Future<HelloResponse> hello(ServiceCall call, Hello request) async {
    // get the application context...
    var ctx = await getContext(call);
    var e = ctx.session.claims.email;

    logger.info('Hello request message= ${request.message} from=$e  extra context = ${ctx.extraGreeting}');

    return HelloResponse(
        message:
            'hello authenticated person $e. \nI got your message "${request.message}"');
  }

  /// Example that we will put on the no_authenticated list
  @override
  Future<HelloResponse> hello_no_auth(ServiceCall call, Hello request) async {
    // dont call getContext() on unauthenticated calls
    logger.info('Hello no auth = ${request.message}');
    return HelloResponse(message: 'no auth server method got your message:\n "${request.message}"');
  }
}
