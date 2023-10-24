//
//  Generated code. Do not modify.
//  source: fig.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'fig.pb.dart' as $0;

export 'fig.pb.dart';

@$pb.GrpcServiceName('fig.FigAuthService')
class FigAuthServiceClient extends $grpc.Client {
  static final _$authenticate = $grpc.ClientMethod<$0.AuthenticateRequest, $0.AuthenticateResponse>(
      '/fig.FigAuthService/authenticate',
      ($0.AuthenticateRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.AuthenticateResponse.fromBuffer(value));
  static final _$logoff = $grpc.ClientMethod<$0.LogoffRequest, $0.FigErrorResponse>(
      '/fig.FigAuthService/logoff',
      ($0.LogoffRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.FigErrorResponse.fromBuffer(value));

  FigAuthServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.AuthenticateResponse> authenticate($0.AuthenticateRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$authenticate, request, options: options);
  }

  $grpc.ResponseFuture<$0.FigErrorResponse> logoff($0.LogoffRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$logoff, request, options: options);
  }
}

@$pb.GrpcServiceName('fig.FigAuthService')
abstract class FigAuthServiceBase extends $grpc.Service {
  $core.String get $name => 'fig.FigAuthService';

  FigAuthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.AuthenticateRequest, $0.AuthenticateResponse>(
        'authenticate',
        authenticate_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AuthenticateRequest.fromBuffer(value),
        ($0.AuthenticateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LogoffRequest, $0.FigErrorResponse>(
        'logoff',
        logoff_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LogoffRequest.fromBuffer(value),
        ($0.FigErrorResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.AuthenticateResponse> authenticate_Pre($grpc.ServiceCall call, $async.Future<$0.AuthenticateRequest> request) async {
    return authenticate(call, await request);
  }

  $async.Future<$0.FigErrorResponse> logoff_Pre($grpc.ServiceCall call, $async.Future<$0.LogoffRequest> request) async {
    return logoff(call, await request);
  }

  $async.Future<$0.AuthenticateResponse> authenticate($grpc.ServiceCall call, $0.AuthenticateRequest request);
  $async.Future<$0.FigErrorResponse> logoff($grpc.ServiceCall call, $0.LogoffRequest request);
}
