// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $SessionTblTable extends SessionTbl
    with TableInfo<$SessionTblTable, SessionTblData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionTblTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cookieMeta = const VerificationMeta('cookie');
  @override
  late final GeneratedColumn<String> cookie = GeneratedColumn<String>(
      'cookie', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _lastAccessTimeMeta =
      const VerificationMeta('lastAccessTime');
  @override
  late final GeneratedColumn<DateTime> lastAccessTime =
      GeneratedColumn<DateTime>('last_access_time', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _claimsMeta = const VerificationMeta('claims');
  @override
  late final GeneratedColumn<String> claims = GeneratedColumn<String>(
      'claims', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 1024),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _subjectMeta =
      const VerificationMeta('subject');
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
      'subject', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [cookie, lastAccessTime, createdAt, claims, subject];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_tbl';
  @override
  VerificationContext validateIntegrity(Insertable<SessionTblData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cookie')) {
      context.handle(_cookieMeta,
          cookie.isAcceptableOrUnknown(data['cookie']!, _cookieMeta));
    } else if (isInserting) {
      context.missing(_cookieMeta);
    }
    if (data.containsKey('last_access_time')) {
      context.handle(
          _lastAccessTimeMeta,
          lastAccessTime.isAcceptableOrUnknown(
              data['last_access_time']!, _lastAccessTimeMeta));
    } else if (isInserting) {
      context.missing(_lastAccessTimeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('claims')) {
      context.handle(_claimsMeta,
          claims.isAcceptableOrUnknown(data['claims']!, _claimsMeta));
    } else if (isInserting) {
      context.missing(_claimsMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(_subjectMeta,
          subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta));
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cookie};
  @override
  SessionTblData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionTblData(
      cookie: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cookie'])!,
      lastAccessTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_access_time'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      claims: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}claims'])!,
      subject: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject'])!,
    );
  }

  @override
  $SessionTblTable createAlias(String alias) {
    return $SessionTblTable(attachedDatabase, alias);
  }
}

class SessionTblData extends DataClass implements Insertable<SessionTblData> {
  final String cookie;
  final DateTime lastAccessTime;
  final DateTime createdAt;
  final String claims;

  /// The oidc subject
  /// Note the same subject could be logged in more than once
  /// So this is not a unique column
  final String subject;
  const SessionTblData(
      {required this.cookie,
      required this.lastAccessTime,
      required this.createdAt,
      required this.claims,
      required this.subject});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cookie'] = Variable<String>(cookie);
    map['last_access_time'] = Variable<DateTime>(lastAccessTime);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['claims'] = Variable<String>(claims);
    map['subject'] = Variable<String>(subject);
    return map;
  }

  SessionTblCompanion toCompanion(bool nullToAbsent) {
    return SessionTblCompanion(
      cookie: Value(cookie),
      lastAccessTime: Value(lastAccessTime),
      createdAt: Value(createdAt),
      claims: Value(claims),
      subject: Value(subject),
    );
  }

  factory SessionTblData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionTblData(
      cookie: serializer.fromJson<String>(json['cookie']),
      lastAccessTime: serializer.fromJson<DateTime>(json['lastAccessTime']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      claims: serializer.fromJson<String>(json['claims']),
      subject: serializer.fromJson<String>(json['subject']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cookie': serializer.toJson<String>(cookie),
      'lastAccessTime': serializer.toJson<DateTime>(lastAccessTime),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'claims': serializer.toJson<String>(claims),
      'subject': serializer.toJson<String>(subject),
    };
  }

  SessionTblData copyWith(
          {String? cookie,
          DateTime? lastAccessTime,
          DateTime? createdAt,
          String? claims,
          String? subject}) =>
      SessionTblData(
        cookie: cookie ?? this.cookie,
        lastAccessTime: lastAccessTime ?? this.lastAccessTime,
        createdAt: createdAt ?? this.createdAt,
        claims: claims ?? this.claims,
        subject: subject ?? this.subject,
      );
  @override
  String toString() {
    return (StringBuffer('SessionTblData(')
          ..write('cookie: $cookie, ')
          ..write('lastAccessTime: $lastAccessTime, ')
          ..write('createdAt: $createdAt, ')
          ..write('claims: $claims, ')
          ..write('subject: $subject')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(cookie, lastAccessTime, createdAt, claims, subject);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionTblData &&
          other.cookie == this.cookie &&
          other.lastAccessTime == this.lastAccessTime &&
          other.createdAt == this.createdAt &&
          other.claims == this.claims &&
          other.subject == this.subject);
}

class SessionTblCompanion extends UpdateCompanion<SessionTblData> {
  final Value<String> cookie;
  final Value<DateTime> lastAccessTime;
  final Value<DateTime> createdAt;
  final Value<String> claims;
  final Value<String> subject;
  final Value<int> rowid;
  const SessionTblCompanion({
    this.cookie = const Value.absent(),
    this.lastAccessTime = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.claims = const Value.absent(),
    this.subject = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionTblCompanion.insert({
    required String cookie,
    required DateTime lastAccessTime,
    required DateTime createdAt,
    required String claims,
    required String subject,
    this.rowid = const Value.absent(),
  })  : cookie = Value(cookie),
        lastAccessTime = Value(lastAccessTime),
        createdAt = Value(createdAt),
        claims = Value(claims),
        subject = Value(subject);
  static Insertable<SessionTblData> custom({
    Expression<String>? cookie,
    Expression<DateTime>? lastAccessTime,
    Expression<DateTime>? createdAt,
    Expression<String>? claims,
    Expression<String>? subject,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cookie != null) 'cookie': cookie,
      if (lastAccessTime != null) 'last_access_time': lastAccessTime,
      if (createdAt != null) 'created_at': createdAt,
      if (claims != null) 'claims': claims,
      if (subject != null) 'subject': subject,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionTblCompanion copyWith(
      {Value<String>? cookie,
      Value<DateTime>? lastAccessTime,
      Value<DateTime>? createdAt,
      Value<String>? claims,
      Value<String>? subject,
      Value<int>? rowid}) {
    return SessionTblCompanion(
      cookie: cookie ?? this.cookie,
      lastAccessTime: lastAccessTime ?? this.lastAccessTime,
      createdAt: createdAt ?? this.createdAt,
      claims: claims ?? this.claims,
      subject: subject ?? this.subject,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cookie.present) {
      map['cookie'] = Variable<String>(cookie.value);
    }
    if (lastAccessTime.present) {
      map['last_access_time'] = Variable<DateTime>(lastAccessTime.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (claims.present) {
      map['claims'] = Variable<String>(claims.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionTblCompanion(')
          ..write('cookie: $cookie, ')
          ..write('lastAccessTime: $lastAccessTime, ')
          ..write('createdAt: $createdAt, ')
          ..write('claims: $claims, ')
          ..write('subject: $subject, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  late final $SessionTblTable sessionTbl = $SessionTblTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [sessionTbl];
}
