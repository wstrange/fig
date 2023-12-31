// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      cookie: json['cookie'] as String,
      claims: OpenIdClaims.fromJson(json['claims'] as Map<String, dynamic>),
      lastAccessTime: DateTime.parse(json['lastAccessTime'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    )..persisted = json['persisted'] as bool;

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'cookie': instance.cookie,
      'claims': Session._claims2Json(instance.claims),
      'lastAccessTime': instance.lastAccessTime.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'persisted': instance.persisted,
    };
