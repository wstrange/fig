//
//  Generated code. Do not modify.
//  source: fig.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// / Authenticate to the server with an OIDC token. The token will be
///  validated, and if OK, a session will be created.
class AuthenticateRequest extends $pb.GeneratedMessage {
  factory AuthenticateRequest({
    $core.String? idToken,
    $core.Map<$core.String, $core.String>? additionalAuthData,
  }) {
    final $result = create();
    if (idToken != null) {
      $result.idToken = idToken;
    }
    if (additionalAuthData != null) {
      $result.additionalAuthData.addAll(additionalAuthData);
    }
    return $result;
  }
  AuthenticateRequest._() : super();
  factory AuthenticateRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthenticateRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthenticateRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'fig'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'idToken', protoName: 'idToken')
    ..m<$core.String, $core.String>(2, _omitFieldNames ? '' : 'additionalAuthData', protoName: 'additionalAuthData', entryClassName: 'AuthenticateRequest.AdditionalAuthDataEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('fig'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AuthenticateRequest clone() => AuthenticateRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AuthenticateRequest copyWith(void Function(AuthenticateRequest) updates) => super.copyWith((message) => updates(message as AuthenticateRequest)) as AuthenticateRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthenticateRequest create() => AuthenticateRequest._();
  AuthenticateRequest createEmptyInstance() => create();
  static $pb.PbList<AuthenticateRequest> createRepeated() => $pb.PbList<AuthenticateRequest>();
  @$core.pragma('dart2js:noInline')
  static AuthenticateRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthenticateRequest>(create);
  static AuthenticateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get idToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set idToken($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIdToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdToken() => clearField(1);

  /// additional data provided by the client
  ///  to the server to inform the auth decision (for example,
  /// a member id entered into a text box).
  /// This provides more context for the server plugin to make an auth decision.
  /// The client and server must sync on the format
  @$pb.TagNumber(2)
  $core.Map<$core.String, $core.String> get additionalAuthData => $_getMap(1);
}

/// Responses.
class FigErrorResponse extends $pb.GeneratedMessage {
  factory FigErrorResponse({
    $core.int? code,
    $core.String? message,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  FigErrorResponse._() : super();
  factory FigErrorResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FigErrorResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FigErrorResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'fig'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FigErrorResponse clone() => FigErrorResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FigErrorResponse copyWith(void Function(FigErrorResponse) updates) => super.copyWith((message) => updates(message as FigErrorResponse)) as FigErrorResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FigErrorResponse create() => FigErrorResponse._();
  FigErrorResponse createEmptyInstance() => create();
  static $pb.PbList<FigErrorResponse> createRepeated() => $pb.PbList<FigErrorResponse>();
  @$core.pragma('dart2js:noInline')
  static FigErrorResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FigErrorResponse>(create);
  static FigErrorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class AuthenticateResponse extends $pb.GeneratedMessage {
  factory AuthenticateResponse({
    $core.String? sessionToken,
    FigErrorResponse? error,
  }) {
    final $result = create();
    if (sessionToken != null) {
      $result.sessionToken = sessionToken;
    }
    if (error != null) {
      $result.error = error;
    }
    return $result;
  }
  AuthenticateResponse._() : super();
  factory AuthenticateResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthenticateResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthenticateResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'fig'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionToken', protoName: 'sessionToken')
    ..aOM<FigErrorResponse>(2, _omitFieldNames ? '' : 'error', subBuilder: FigErrorResponse.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AuthenticateResponse clone() => AuthenticateResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AuthenticateResponse copyWith(void Function(AuthenticateResponse) updates) => super.copyWith((message) => updates(message as AuthenticateResponse)) as AuthenticateResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthenticateResponse create() => AuthenticateResponse._();
  AuthenticateResponse createEmptyInstance() => create();
  static $pb.PbList<AuthenticateResponse> createRepeated() => $pb.PbList<AuthenticateResponse>();
  @$core.pragma('dart2js:noInline')
  static AuthenticateResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthenticateResponse>(create);
  static AuthenticateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionToken($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionToken() => clearField(1);

  @$pb.TagNumber(2)
  FigErrorResponse get error => $_getN(1);
  @$pb.TagNumber(2)
  set error(FigErrorResponse v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => clearField(2);
  @$pb.TagNumber(2)
  FigErrorResponse ensureError() => $_ensure(1);
}

class LogoffRequest extends $pb.GeneratedMessage {
  factory LogoffRequest() => create();
  LogoffRequest._() : super();
  factory LogoffRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LogoffRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LogoffRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'fig'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LogoffRequest clone() => LogoffRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LogoffRequest copyWith(void Function(LogoffRequest) updates) => super.copyWith((message) => updates(message as LogoffRequest)) as LogoffRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogoffRequest create() => LogoffRequest._();
  LogoffRequest createEmptyInstance() => create();
  static $pb.PbList<LogoffRequest> createRepeated() => $pb.PbList<LogoffRequest>();
  @$core.pragma('dart2js:noInline')
  static LogoffRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LogoffRequest>(create);
  static LogoffRequest? _defaultInstance;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
