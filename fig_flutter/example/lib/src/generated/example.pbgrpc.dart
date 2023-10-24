//
//  Generated code. Do not modify.
//  source: example.proto
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

import 'example.pb.dart' as $0;

export 'example.pb.dart';

@$pb.GrpcServiceName('fig_serv.Example')
class ExampleClient extends $grpc.Client {
  static final _$hello = $grpc.ClientMethod<$0.Hello, $0.HelloResponse>(
      '/fig_serv.Example/hello',
      ($0.Hello value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.HelloResponse.fromBuffer(value));
  static final _$hello_no_auth = $grpc.ClientMethod<$0.Hello, $0.HelloResponse>(
      '/fig_serv.Example/hello_no_auth',
      ($0.Hello value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.HelloResponse.fromBuffer(value));

  ExampleClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.HelloResponse> hello($0.Hello request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$hello, request, options: options);
  }

  $grpc.ResponseFuture<$0.HelloResponse> hello_no_auth($0.Hello request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$hello_no_auth, request, options: options);
  }
}

@$pb.GrpcServiceName('fig_serv.Example')
abstract class ExampleServiceBase extends $grpc.Service {
  $core.String get $name => 'fig_serv.Example';

  ExampleServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Hello, $0.HelloResponse>(
        'hello',
        hello_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Hello.fromBuffer(value),
        ($0.HelloResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Hello, $0.HelloResponse>(
        'hello_no_auth',
        hello_no_auth_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Hello.fromBuffer(value),
        ($0.HelloResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.HelloResponse> hello_Pre($grpc.ServiceCall call, $async.Future<$0.Hello> request) async {
    return hello(call, await request);
  }

  $async.Future<$0.HelloResponse> hello_no_auth_Pre($grpc.ServiceCall call, $async.Future<$0.Hello> request) async {
    return hello_no_auth(call, await request);
  }

  $async.Future<$0.HelloResponse> hello($grpc.ServiceCall call, $0.Hello request);
  $async.Future<$0.HelloResponse> hello_no_auth($grpc.ServiceCall call, $0.Hello request);
}
