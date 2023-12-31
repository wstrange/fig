//
//  Generated code. Do not modify.
//  source: fig.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use authenticateRequestDescriptor instead')
const AuthenticateRequest$json = {
  '1': 'AuthenticateRequest',
  '2': [
    {'1': 'idToken', '3': 1, '4': 1, '5': 9, '10': 'idToken'},
    {'1': 'additionalAuthData', '3': 2, '4': 3, '5': 11, '6': '.fig.AuthenticateRequest.AdditionalAuthDataEntry', '10': 'additionalAuthData'},
  ],
  '3': [AuthenticateRequest_AdditionalAuthDataEntry$json],
};

@$core.Deprecated('Use authenticateRequestDescriptor instead')
const AuthenticateRequest_AdditionalAuthDataEntry$json = {
  '1': 'AdditionalAuthDataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `AuthenticateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authenticateRequestDescriptor = $convert.base64Decode(
    'ChNBdXRoZW50aWNhdGVSZXF1ZXN0EhgKB2lkVG9rZW4YASABKAlSB2lkVG9rZW4SYAoSYWRkaX'
    'Rpb25hbEF1dGhEYXRhGAIgAygLMjAuZmlnLkF1dGhlbnRpY2F0ZVJlcXVlc3QuQWRkaXRpb25h'
    'bEF1dGhEYXRhRW50cnlSEmFkZGl0aW9uYWxBdXRoRGF0YRpFChdBZGRpdGlvbmFsQXV0aERhdG'
    'FFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use figErrorResponseDescriptor instead')
const FigErrorResponse$json = {
  '1': 'FigErrorResponse',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `FigErrorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List figErrorResponseDescriptor = $convert.base64Decode(
    'ChBGaWdFcnJvclJlc3BvbnNlEhIKBGNvZGUYASABKAVSBGNvZGUSGAoHbWVzc2FnZRgCIAEoCV'
    'IHbWVzc2FnZQ==');

@$core.Deprecated('Use authenticateResponseDescriptor instead')
const AuthenticateResponse$json = {
  '1': 'AuthenticateResponse',
  '2': [
    {'1': 'sessionToken', '3': 1, '4': 1, '5': 9, '10': 'sessionToken'},
    {'1': 'error', '3': 2, '4': 1, '5': 11, '6': '.fig.FigErrorResponse', '10': 'error'},
  ],
};

/// Descriptor for `AuthenticateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authenticateResponseDescriptor = $convert.base64Decode(
    'ChRBdXRoZW50aWNhdGVSZXNwb25zZRIiCgxzZXNzaW9uVG9rZW4YASABKAlSDHNlc3Npb25Ub2'
    'tlbhIrCgVlcnJvchgCIAEoCzIVLmZpZy5GaWdFcnJvclJlc3BvbnNlUgVlcnJvcg==');

@$core.Deprecated('Use logoffRequestDescriptor instead')
const LogoffRequest$json = {
  '1': 'LogoffRequest',
};

/// Descriptor for `LogoffRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoffRequestDescriptor = $convert.base64Decode(
    'Cg1Mb2dvZmZSZXF1ZXN0');

