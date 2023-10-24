import 'package:grpc/grpc.dart';
import 'package:logging/logging.dart';

final _logger = Logger('grpc');

Future<GrpcError?> loggingInterceptor(
    ServiceCall call,
    ServiceMethod method,
    ) async {
  final dateTime = DateTime.now();
  final clientMetadata = call.clientMetadata ?? {};
  final authority = clientMetadata[':authority'];
  final methodName = clientMetadata[':path'];
  final method = clientMetadata[':method'];
  final userAgent = clientMetadata['user-agent'];

  _logger.info('$authority - - [$dateTime] $method $methodName $userAgent');
  return null;
}
