import 'package:fig_auth/fig_auth.dart';

import 'src/generated/example.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:logging/logging.dart';

final logger = Logger('mySvc');

// Sample RPC service
class MySvc extends ExampleServiceBase {
  final SessionManager sessionManager;

  MySvc(this.sessionManager);

  /// Example method to fetch the callers context
  /// Your service methods will call this at the start of each method.
  Future<Session> getSession(ServiceCall call) async {
    var s = await sessionManager.getSession(call.clientMetadata?['authorization'] ?? '');
    // todo: maybe throw here instead?
    return s!;
  }

  // If the method is authenticated, the call to getSession should always work..
  @override
  Future<HelloResponse> hello(ServiceCall call, Hello request) async {
    // get the session context...
    var session = await getSession(call);
    var e = session.claims.email;

    logger.info(
        'Hello request message= ${request.message} from=$e');

    return HelloResponse(
        message:
            'hello authenticated person $e. \nI got your message "${request.message}"');
  }

  /// Example that we will put on the no_authenticated list
  @override
  Future<HelloResponse> hello_no_auth(ServiceCall call, Hello request) async {
    // dont call getContext() on unauthenticated calls
    logger.info('Hello no auth = ${request.message}');
    return HelloResponse(
        message:
            'Unauthenticated server method got your message:\n "${request.message}"');
  }
}
