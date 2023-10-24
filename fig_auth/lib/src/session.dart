// maintain a session cache for logged in users
//

import 'dart:convert';

import 'package:openid_client/openid_client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session.g.dart';

/// Represents a server session for an authenticated user.
/// Contains data we need to evalaute the users roles, etc.
/// You can include custom json [data] that will be serialized
/// when the session is persisted.
@JsonSerializable()
class Session {
  ///  [cookie] - an opaque random string representing the session
  ///  This cookie is the session 'authenticate' header passed in gRPC.
  final String cookie;

  @JsonKey(toJson: _claims2Json)
  /// [claims] are OIDC Claims from the identity provider (Firebase)
  final OpenIdClaims claims;

  /// When the session was last accessed
  DateTime lastAccessTime;

  /// When the session was first created
  final DateTime createdAt;

  /// If the session has been persisted, or is just in memory
  bool persisted = false;

  ///  [data] is an optional map used to pass
  /// data back from a server plugin to the client.
  /// This must be serializable toJson / fromJson to be passed
  /// over the wire.
  final Map<String,dynamic> data;

  /// Create a new session.
  ///
  /// [cookie] is the opaque session id.
  /// [claims] are the oidc claims from the provider.
  /// [data] is additional data provided by plugins
  Session({
    required this.cookie,
    required this.claims,
    required this.lastAccessTime,
    required this.createdAt,
    required this.data,
  });

  factory Session.fromJson(Map<String,dynamic> json) => _$SessionFromJson(json);
  Map<String,dynamic> toJson() => _$SessionToJson(this);

  // Needed to cast the claims to a Map type.
  static Map _claims2Json(OpenIdClaims claims) => claims.toJson();

  String toJsonString() => jsonEncode(toJson());

  @override
  String toString() => toJson().toString();
}
