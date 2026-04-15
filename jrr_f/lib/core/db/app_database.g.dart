// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SavedServersTable extends SavedServers
    with TableInfo<$SavedServersTable, SavedServer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedServersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _hostMeta = const VerificationMeta('host');
  @override
  late final GeneratedColumn<String> host = GeneratedColumn<String>(
    'host',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(52199),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordKeyMeta = const VerificationMeta(
    'passwordKey',
  );
  @override
  late final GeneratedColumn<String> passwordKey = GeneratedColumn<String>(
    'password_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _friendlyNameMeta = const VerificationMeta(
    'friendlyName',
  );
  @override
  late final GeneratedColumn<String> friendlyName = GeneratedColumn<String>(
    'friendly_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<int> lastUsedAt = GeneratedColumn<int>(
    'last_used_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authTokenMeta = const VerificationMeta(
    'authToken',
  );
  @override
  late final GeneratedColumn<String> authToken = GeneratedColumn<String>(
    'auth_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    host,
    port,
    username,
    passwordKey,
    friendlyName,
    lastUsedAt,
    authToken,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_servers';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedServer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('host')) {
      context.handle(
        _hostMeta,
        host.isAcceptableOrUnknown(data['host']!, _hostMeta),
      );
    } else if (isInserting) {
      context.missing(_hostMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password_key')) {
      context.handle(
        _passwordKeyMeta,
        passwordKey.isAcceptableOrUnknown(
          data['password_key']!,
          _passwordKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordKeyMeta);
    }
    if (data.containsKey('friendly_name')) {
      context.handle(
        _friendlyNameMeta,
        friendlyName.isAcceptableOrUnknown(
          data['friendly_name']!,
          _friendlyNameMeta,
        ),
      );
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    }
    if (data.containsKey('auth_token')) {
      context.handle(
        _authTokenMeta,
        authToken.isAcceptableOrUnknown(data['auth_token']!, _authTokenMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedServer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedServer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      host: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}host'],
      )!,
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}port'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      passwordKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_key'],
      )!,
      friendlyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}friendly_name'],
      ),
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_used_at'],
      ),
      authToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auth_token'],
      ),
    );
  }

  @override
  $SavedServersTable createAlias(String alias) {
    return $SavedServersTable(attachedDatabase, alias);
  }
}

class SavedServer extends DataClass implements Insertable<SavedServer> {
  final int id;
  final String host;
  final int port;
  final String username;

  /// Key used to look up the password in flutter_secure_storage.
  final String passwordKey;

  /// Cached friendly name from the last successful Alive call.
  final String? friendlyName;

  /// Last successful connection timestamp (unix ms). Used for auto-selection.
  final int? lastUsedAt;

  /// Cached auth token from the last successful authentication.
  final String? authToken;
  const SavedServer({
    required this.id,
    required this.host,
    required this.port,
    required this.username,
    required this.passwordKey,
    this.friendlyName,
    this.lastUsedAt,
    this.authToken,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['host'] = Variable<String>(host);
    map['port'] = Variable<int>(port);
    map['username'] = Variable<String>(username);
    map['password_key'] = Variable<String>(passwordKey);
    if (!nullToAbsent || friendlyName != null) {
      map['friendly_name'] = Variable<String>(friendlyName);
    }
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<int>(lastUsedAt);
    }
    if (!nullToAbsent || authToken != null) {
      map['auth_token'] = Variable<String>(authToken);
    }
    return map;
  }

  SavedServersCompanion toCompanion(bool nullToAbsent) {
    return SavedServersCompanion(
      id: Value(id),
      host: Value(host),
      port: Value(port),
      username: Value(username),
      passwordKey: Value(passwordKey),
      friendlyName: friendlyName == null && nullToAbsent
          ? const Value.absent()
          : Value(friendlyName),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      authToken: authToken == null && nullToAbsent
          ? const Value.absent()
          : Value(authToken),
    );
  }

  factory SavedServer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedServer(
      id: serializer.fromJson<int>(json['id']),
      host: serializer.fromJson<String>(json['host']),
      port: serializer.fromJson<int>(json['port']),
      username: serializer.fromJson<String>(json['username']),
      passwordKey: serializer.fromJson<String>(json['passwordKey']),
      friendlyName: serializer.fromJson<String?>(json['friendlyName']),
      lastUsedAt: serializer.fromJson<int?>(json['lastUsedAt']),
      authToken: serializer.fromJson<String?>(json['authToken']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'host': serializer.toJson<String>(host),
      'port': serializer.toJson<int>(port),
      'username': serializer.toJson<String>(username),
      'passwordKey': serializer.toJson<String>(passwordKey),
      'friendlyName': serializer.toJson<String?>(friendlyName),
      'lastUsedAt': serializer.toJson<int?>(lastUsedAt),
      'authToken': serializer.toJson<String?>(authToken),
    };
  }

  SavedServer copyWith({
    int? id,
    String? host,
    int? port,
    String? username,
    String? passwordKey,
    Value<String?> friendlyName = const Value.absent(),
    Value<int?> lastUsedAt = const Value.absent(),
    Value<String?> authToken = const Value.absent(),
  }) => SavedServer(
    id: id ?? this.id,
    host: host ?? this.host,
    port: port ?? this.port,
    username: username ?? this.username,
    passwordKey: passwordKey ?? this.passwordKey,
    friendlyName: friendlyName.present ? friendlyName.value : this.friendlyName,
    lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
    authToken: authToken.present ? authToken.value : this.authToken,
  );
  SavedServer copyWithCompanion(SavedServersCompanion data) {
    return SavedServer(
      id: data.id.present ? data.id.value : this.id,
      host: data.host.present ? data.host.value : this.host,
      port: data.port.present ? data.port.value : this.port,
      username: data.username.present ? data.username.value : this.username,
      passwordKey: data.passwordKey.present
          ? data.passwordKey.value
          : this.passwordKey,
      friendlyName: data.friendlyName.present
          ? data.friendlyName.value
          : this.friendlyName,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
      authToken: data.authToken.present ? data.authToken.value : this.authToken,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedServer(')
          ..write('id: $id, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('username: $username, ')
          ..write('passwordKey: $passwordKey, ')
          ..write('friendlyName: $friendlyName, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('authToken: $authToken')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    host,
    port,
    username,
    passwordKey,
    friendlyName,
    lastUsedAt,
    authToken,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedServer &&
          other.id == this.id &&
          other.host == this.host &&
          other.port == this.port &&
          other.username == this.username &&
          other.passwordKey == this.passwordKey &&
          other.friendlyName == this.friendlyName &&
          other.lastUsedAt == this.lastUsedAt &&
          other.authToken == this.authToken);
}

class SavedServersCompanion extends UpdateCompanion<SavedServer> {
  final Value<int> id;
  final Value<String> host;
  final Value<int> port;
  final Value<String> username;
  final Value<String> passwordKey;
  final Value<String?> friendlyName;
  final Value<int?> lastUsedAt;
  final Value<String?> authToken;
  const SavedServersCompanion({
    this.id = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordKey = const Value.absent(),
    this.friendlyName = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.authToken = const Value.absent(),
  });
  SavedServersCompanion.insert({
    this.id = const Value.absent(),
    required String host,
    this.port = const Value.absent(),
    required String username,
    required String passwordKey,
    this.friendlyName = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.authToken = const Value.absent(),
  }) : host = Value(host),
       username = Value(username),
       passwordKey = Value(passwordKey);
  static Insertable<SavedServer> custom({
    Expression<int>? id,
    Expression<String>? host,
    Expression<int>? port,
    Expression<String>? username,
    Expression<String>? passwordKey,
    Expression<String>? friendlyName,
    Expression<int>? lastUsedAt,
    Expression<String>? authToken,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (host != null) 'host': host,
      if (port != null) 'port': port,
      if (username != null) 'username': username,
      if (passwordKey != null) 'password_key': passwordKey,
      if (friendlyName != null) 'friendly_name': friendlyName,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (authToken != null) 'auth_token': authToken,
    });
  }

  SavedServersCompanion copyWith({
    Value<int>? id,
    Value<String>? host,
    Value<int>? port,
    Value<String>? username,
    Value<String>? passwordKey,
    Value<String?>? friendlyName,
    Value<int?>? lastUsedAt,
    Value<String?>? authToken,
  }) {
    return SavedServersCompanion(
      id: id ?? this.id,
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      passwordKey: passwordKey ?? this.passwordKey,
      friendlyName: friendlyName ?? this.friendlyName,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      authToken: authToken ?? this.authToken,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (host.present) {
      map['host'] = Variable<String>(host.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordKey.present) {
      map['password_key'] = Variable<String>(passwordKey.value);
    }
    if (friendlyName.present) {
      map['friendly_name'] = Variable<String>(friendlyName.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<int>(lastUsedAt.value);
    }
    if (authToken.present) {
      map['auth_token'] = Variable<String>(authToken.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedServersCompanion(')
          ..write('id: $id, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('username: $username, ')
          ..write('passwordKey: $passwordKey, ')
          ..write('friendlyName: $friendlyName, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('authToken: $authToken')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SavedServersTable savedServers = $SavedServersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [savedServers];
}

typedef $$SavedServersTableCreateCompanionBuilder =
    SavedServersCompanion Function({
      Value<int> id,
      required String host,
      Value<int> port,
      required String username,
      required String passwordKey,
      Value<String?> friendlyName,
      Value<int?> lastUsedAt,
      Value<String?> authToken,
    });
typedef $$SavedServersTableUpdateCompanionBuilder =
    SavedServersCompanion Function({
      Value<int> id,
      Value<String> host,
      Value<int> port,
      Value<String> username,
      Value<String> passwordKey,
      Value<String?> friendlyName,
      Value<int?> lastUsedAt,
      Value<String?> authToken,
    });

class $$SavedServersTableFilterComposer
    extends Composer<_$AppDatabase, $SavedServersTable> {
  $$SavedServersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordKey => $composableBuilder(
    column: $table.passwordKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get friendlyName => $composableBuilder(
    column: $table.friendlyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authToken => $composableBuilder(
    column: $table.authToken,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedServersTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedServersTable> {
  $$SavedServersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordKey => $composableBuilder(
    column: $table.passwordKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get friendlyName => $composableBuilder(
    column: $table.friendlyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authToken => $composableBuilder(
    column: $table.authToken,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedServersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedServersTable> {
  $$SavedServersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get host =>
      $composableBuilder(column: $table.host, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get passwordKey => $composableBuilder(
    column: $table.passwordKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get friendlyName => $composableBuilder(
    column: $table.friendlyName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authToken =>
      $composableBuilder(column: $table.authToken, builder: (column) => column);
}

class $$SavedServersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedServersTable,
          SavedServer,
          $$SavedServersTableFilterComposer,
          $$SavedServersTableOrderingComposer,
          $$SavedServersTableAnnotationComposer,
          $$SavedServersTableCreateCompanionBuilder,
          $$SavedServersTableUpdateCompanionBuilder,
          (
            SavedServer,
            BaseReferences<_$AppDatabase, $SavedServersTable, SavedServer>,
          ),
          SavedServer,
          PrefetchHooks Function()
        > {
  $$SavedServersTableTableManager(_$AppDatabase db, $SavedServersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedServersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedServersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedServersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> host = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> passwordKey = const Value.absent(),
                Value<String?> friendlyName = const Value.absent(),
                Value<int?> lastUsedAt = const Value.absent(),
                Value<String?> authToken = const Value.absent(),
              }) => SavedServersCompanion(
                id: id,
                host: host,
                port: port,
                username: username,
                passwordKey: passwordKey,
                friendlyName: friendlyName,
                lastUsedAt: lastUsedAt,
                authToken: authToken,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String host,
                Value<int> port = const Value.absent(),
                required String username,
                required String passwordKey,
                Value<String?> friendlyName = const Value.absent(),
                Value<int?> lastUsedAt = const Value.absent(),
                Value<String?> authToken = const Value.absent(),
              }) => SavedServersCompanion.insert(
                id: id,
                host: host,
                port: port,
                username: username,
                passwordKey: passwordKey,
                friendlyName: friendlyName,
                lastUsedAt: lastUsedAt,
                authToken: authToken,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedServersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedServersTable,
      SavedServer,
      $$SavedServersTableFilterComposer,
      $$SavedServersTableOrderingComposer,
      $$SavedServersTableAnnotationComposer,
      $$SavedServersTableCreateCompanionBuilder,
      $$SavedServersTableUpdateCompanionBuilder,
      (
        SavedServer,
        BaseReferences<_$AppDatabase, $SavedServersTable, SavedServer>,
      ),
      SavedServer,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SavedServersTableTableManager get savedServers =>
      $$SavedServersTableTableManager(_db, _db.savedServers);
}
