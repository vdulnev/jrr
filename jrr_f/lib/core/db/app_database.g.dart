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
  static const VerificationMeta _useSslMeta = const VerificationMeta('useSsl');
  @override
  late final GeneratedColumn<bool> useSsl = GeneratedColumn<bool>(
    'use_ssl',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_ssl" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sslPortMeta = const VerificationMeta(
    'sslPort',
  );
  @override
  late final GeneratedColumn<int> sslPort = GeneratedColumn<int>(
    'ssl_port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(52200),
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
    useSsl,
    sslPort,
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
    if (data.containsKey('use_ssl')) {
      context.handle(
        _useSslMeta,
        useSsl.isAcceptableOrUnknown(data['use_ssl']!, _useSslMeta),
      );
    }
    if (data.containsKey('ssl_port')) {
      context.handle(
        _sslPortMeta,
        sslPort.isAcceptableOrUnknown(data['ssl_port']!, _sslPortMeta),
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
      useSsl: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_ssl'],
      )!,
      sslPort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ssl_port'],
      )!,
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

  /// Connect over HTTPS instead of HTTP. JRiver MC's HTTPS uses a self-signed
  /// certificate, so the network layer must be configured to accept it.
  final bool useSsl;

  /// HTTPS port (default JRiver MC SSL port is 52200). Used only when
  /// [useSsl] is true.
  final int sslPort;
  const SavedServer({
    required this.id,
    required this.host,
    required this.port,
    required this.username,
    required this.passwordKey,
    this.friendlyName,
    this.lastUsedAt,
    this.authToken,
    required this.useSsl,
    required this.sslPort,
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
    map['use_ssl'] = Variable<bool>(useSsl);
    map['ssl_port'] = Variable<int>(sslPort);
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
      useSsl: Value(useSsl),
      sslPort: Value(sslPort),
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
      useSsl: serializer.fromJson<bool>(json['useSsl']),
      sslPort: serializer.fromJson<int>(json['sslPort']),
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
      'useSsl': serializer.toJson<bool>(useSsl),
      'sslPort': serializer.toJson<int>(sslPort),
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
    bool? useSsl,
    int? sslPort,
  }) => SavedServer(
    id: id ?? this.id,
    host: host ?? this.host,
    port: port ?? this.port,
    username: username ?? this.username,
    passwordKey: passwordKey ?? this.passwordKey,
    friendlyName: friendlyName.present ? friendlyName.value : this.friendlyName,
    lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
    authToken: authToken.present ? authToken.value : this.authToken,
    useSsl: useSsl ?? this.useSsl,
    sslPort: sslPort ?? this.sslPort,
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
      useSsl: data.useSsl.present ? data.useSsl.value : this.useSsl,
      sslPort: data.sslPort.present ? data.sslPort.value : this.sslPort,
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
          ..write('authToken: $authToken, ')
          ..write('useSsl: $useSsl, ')
          ..write('sslPort: $sslPort')
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
    useSsl,
    sslPort,
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
          other.authToken == this.authToken &&
          other.useSsl == this.useSsl &&
          other.sslPort == this.sslPort);
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
  final Value<bool> useSsl;
  final Value<int> sslPort;
  const SavedServersCompanion({
    this.id = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordKey = const Value.absent(),
    this.friendlyName = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.authToken = const Value.absent(),
    this.useSsl = const Value.absent(),
    this.sslPort = const Value.absent(),
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
    this.useSsl = const Value.absent(),
    this.sslPort = const Value.absent(),
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
    Expression<bool>? useSsl,
    Expression<int>? sslPort,
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
      if (useSsl != null) 'use_ssl': useSsl,
      if (sslPort != null) 'ssl_port': sslPort,
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
    Value<bool>? useSsl,
    Value<int>? sslPort,
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
      useSsl: useSsl ?? this.useSsl,
      sslPort: sslPort ?? this.sslPort,
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
    if (useSsl.present) {
      map['use_ssl'] = Variable<bool>(useSsl.value);
    }
    if (sslPort.present) {
      map['ssl_port'] = Variable<int>(sslPort.value);
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
          ..write('authToken: $authToken, ')
          ..write('useSsl: $useSsl, ')
          ..write('sslPort: $sslPort')
          ..write(')'))
        .toString();
  }
}

class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, Favorite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _identifierMeta = const VerificationMeta(
    'identifier',
  );
  @override
  late final GeneratedColumn<String> identifier = GeneratedColumn<String>(
    'identifier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<int> addedAt = GeneratedColumn<int>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    identifier,
    displayName,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites';
  @override
  VerificationContext validateIntegrity(
    Insertable<Favorite> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('identifier')) {
      context.handle(
        _identifierMeta,
        identifier.isAcceptableOrUnknown(data['identifier']!, _identifierMeta),
      );
    } else if (isInserting) {
      context.missing(_identifierMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Favorite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Favorite(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      identifier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identifier'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(attachedDatabase, alias);
  }
}

class Favorite extends DataClass implements Insertable<Favorite> {
  final int id;

  /// Type: always 'browse_item'
  final String type;

  /// Browse item node id (String)
  final String identifier;

  /// Display name for the browse item
  final String displayName;

  /// Timestamp when the favorite was added (unix ms)
  final int addedAt;
  const Favorite({
    required this.id,
    required this.type,
    required this.identifier,
    required this.displayName,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['identifier'] = Variable<String>(identifier);
    map['display_name'] = Variable<String>(displayName);
    map['added_at'] = Variable<int>(addedAt);
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      id: Value(id),
      type: Value(type),
      identifier: Value(identifier),
      displayName: Value(displayName),
      addedAt: Value(addedAt),
    );
  }

  factory Favorite.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Favorite(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      identifier: serializer.fromJson<String>(json['identifier']),
      displayName: serializer.fromJson<String>(json['displayName']),
      addedAt: serializer.fromJson<int>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'identifier': serializer.toJson<String>(identifier),
      'displayName': serializer.toJson<String>(displayName),
      'addedAt': serializer.toJson<int>(addedAt),
    };
  }

  Favorite copyWith({
    int? id,
    String? type,
    String? identifier,
    String? displayName,
    int? addedAt,
  }) => Favorite(
    id: id ?? this.id,
    type: type ?? this.type,
    identifier: identifier ?? this.identifier,
    displayName: displayName ?? this.displayName,
    addedAt: addedAt ?? this.addedAt,
  );
  Favorite copyWithCompanion(FavoritesCompanion data) {
    return Favorite(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      identifier: data.identifier.present
          ? data.identifier.value
          : this.identifier,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Favorite(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('identifier: $identifier, ')
          ..write('displayName: $displayName, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, identifier, displayName, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favorite &&
          other.id == this.id &&
          other.type == this.type &&
          other.identifier == this.identifier &&
          other.displayName == this.displayName &&
          other.addedAt == this.addedAt);
}

class FavoritesCompanion extends UpdateCompanion<Favorite> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> identifier;
  final Value<String> displayName;
  final Value<int> addedAt;
  const FavoritesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.identifier = const Value.absent(),
    this.displayName = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  FavoritesCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String identifier,
    required String displayName,
    required int addedAt,
  }) : type = Value(type),
       identifier = Value(identifier),
       displayName = Value(displayName),
       addedAt = Value(addedAt);
  static Insertable<Favorite> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? identifier,
    Expression<String>? displayName,
    Expression<int>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (identifier != null) 'identifier': identifier,
      if (displayName != null) 'display_name': displayName,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  FavoritesCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<String>? identifier,
    Value<String>? displayName,
    Value<int>? addedAt,
  }) {
    return FavoritesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      identifier: identifier ?? this.identifier,
      displayName: displayName ?? this.displayName,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (identifier.present) {
      map['identifier'] = Variable<String>(identifier.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<int>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('identifier: $identifier, ')
          ..write('displayName: $displayName, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

class $LocalQueueTracksTable extends LocalQueueTracks
    with TableInfo<$LocalQueueTracksTable, LocalQueueTrack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalQueueTracksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _zoneIdMeta = const VerificationMeta('zoneId');
  @override
  late final GeneratedColumn<String> zoneId = GeneratedColumn<String>(
    'zone_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('local'),
  );
  static const VerificationMeta _fileKeyMeta = const VerificationMeta(
    'fileKey',
  );
  @override
  late final GeneratedColumn<int> fileKey = GeneratedColumn<int>(
    'file_key',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackJsonMeta = const VerificationMeta(
    'trackJson',
  );
  @override
  late final GeneratedColumn<String> trackJson = GeneratedColumn<String>(
    'track_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    zoneId,
    fileKey,
    trackJson,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_queue_tracks';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalQueueTrack> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('zone_id')) {
      context.handle(
        _zoneIdMeta,
        zoneId.isAcceptableOrUnknown(data['zone_id']!, _zoneIdMeta),
      );
    }
    if (data.containsKey('file_key')) {
      context.handle(
        _fileKeyMeta,
        fileKey.isAcceptableOrUnknown(data['file_key']!, _fileKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_fileKeyMeta);
    }
    if (data.containsKey('track_json')) {
      context.handle(
        _trackJsonMeta,
        trackJson.isAcceptableOrUnknown(data['track_json']!, _trackJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_trackJsonMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalQueueTrack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalQueueTrack(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      zoneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zone_id'],
      )!,
      fileKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_key'],
      )!,
      trackJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}track_json'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $LocalQueueTracksTable createAlias(String alias) {
    return $LocalQueueTracksTable(attachedDatabase, alias);
  }
}

class LocalQueueTrack extends DataClass implements Insertable<LocalQueueTrack> {
  final int id;
  final String zoneId;
  final int fileKey;
  final String trackJson;
  final int position;
  const LocalQueueTrack({
    required this.id,
    required this.zoneId,
    required this.fileKey,
    required this.trackJson,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['zone_id'] = Variable<String>(zoneId);
    map['file_key'] = Variable<int>(fileKey);
    map['track_json'] = Variable<String>(trackJson);
    map['position'] = Variable<int>(position);
    return map;
  }

  LocalQueueTracksCompanion toCompanion(bool nullToAbsent) {
    return LocalQueueTracksCompanion(
      id: Value(id),
      zoneId: Value(zoneId),
      fileKey: Value(fileKey),
      trackJson: Value(trackJson),
      position: Value(position),
    );
  }

  factory LocalQueueTrack.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalQueueTrack(
      id: serializer.fromJson<int>(json['id']),
      zoneId: serializer.fromJson<String>(json['zoneId']),
      fileKey: serializer.fromJson<int>(json['fileKey']),
      trackJson: serializer.fromJson<String>(json['trackJson']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'zoneId': serializer.toJson<String>(zoneId),
      'fileKey': serializer.toJson<int>(fileKey),
      'trackJson': serializer.toJson<String>(trackJson),
      'position': serializer.toJson<int>(position),
    };
  }

  LocalQueueTrack copyWith({
    int? id,
    String? zoneId,
    int? fileKey,
    String? trackJson,
    int? position,
  }) => LocalQueueTrack(
    id: id ?? this.id,
    zoneId: zoneId ?? this.zoneId,
    fileKey: fileKey ?? this.fileKey,
    trackJson: trackJson ?? this.trackJson,
    position: position ?? this.position,
  );
  LocalQueueTrack copyWithCompanion(LocalQueueTracksCompanion data) {
    return LocalQueueTrack(
      id: data.id.present ? data.id.value : this.id,
      zoneId: data.zoneId.present ? data.zoneId.value : this.zoneId,
      fileKey: data.fileKey.present ? data.fileKey.value : this.fileKey,
      trackJson: data.trackJson.present ? data.trackJson.value : this.trackJson,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalQueueTrack(')
          ..write('id: $id, ')
          ..write('zoneId: $zoneId, ')
          ..write('fileKey: $fileKey, ')
          ..write('trackJson: $trackJson, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, zoneId, fileKey, trackJson, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalQueueTrack &&
          other.id == this.id &&
          other.zoneId == this.zoneId &&
          other.fileKey == this.fileKey &&
          other.trackJson == this.trackJson &&
          other.position == this.position);
}

class LocalQueueTracksCompanion extends UpdateCompanion<LocalQueueTrack> {
  final Value<int> id;
  final Value<String> zoneId;
  final Value<int> fileKey;
  final Value<String> trackJson;
  final Value<int> position;
  const LocalQueueTracksCompanion({
    this.id = const Value.absent(),
    this.zoneId = const Value.absent(),
    this.fileKey = const Value.absent(),
    this.trackJson = const Value.absent(),
    this.position = const Value.absent(),
  });
  LocalQueueTracksCompanion.insert({
    this.id = const Value.absent(),
    this.zoneId = const Value.absent(),
    required int fileKey,
    required String trackJson,
    required int position,
  }) : fileKey = Value(fileKey),
       trackJson = Value(trackJson),
       position = Value(position);
  static Insertable<LocalQueueTrack> custom({
    Expression<int>? id,
    Expression<String>? zoneId,
    Expression<int>? fileKey,
    Expression<String>? trackJson,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (zoneId != null) 'zone_id': zoneId,
      if (fileKey != null) 'file_key': fileKey,
      if (trackJson != null) 'track_json': trackJson,
      if (position != null) 'position': position,
    });
  }

  LocalQueueTracksCompanion copyWith({
    Value<int>? id,
    Value<String>? zoneId,
    Value<int>? fileKey,
    Value<String>? trackJson,
    Value<int>? position,
  }) {
    return LocalQueueTracksCompanion(
      id: id ?? this.id,
      zoneId: zoneId ?? this.zoneId,
      fileKey: fileKey ?? this.fileKey,
      trackJson: trackJson ?? this.trackJson,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (zoneId.present) {
      map['zone_id'] = Variable<String>(zoneId.value);
    }
    if (fileKey.present) {
      map['file_key'] = Variable<int>(fileKey.value);
    }
    if (trackJson.present) {
      map['track_json'] = Variable<String>(trackJson.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalQueueTracksCompanion(')
          ..write('id: $id, ')
          ..write('zoneId: $zoneId, ')
          ..write('fileKey: $fileKey, ')
          ..write('trackJson: $trackJson, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $LocalQueueStateTable extends LocalQueueState
    with TableInfo<$LocalQueueStateTable, LocalQueueStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalQueueStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _zoneIdMeta = const VerificationMeta('zoneId');
  @override
  late final GeneratedColumn<String> zoneId = GeneratedColumn<String>(
    'zone_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentIndexMeta = const VerificationMeta(
    'currentIndex',
  );
  @override
  late final GeneratedColumn<int> currentIndex = GeneratedColumn<int>(
    'current_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(-1),
  );
  @override
  List<GeneratedColumn> get $columns => [zoneId, currentIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_queue_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalQueueStateData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('zone_id')) {
      context.handle(
        _zoneIdMeta,
        zoneId.isAcceptableOrUnknown(data['zone_id']!, _zoneIdMeta),
      );
    } else if (isInserting) {
      context.missing(_zoneIdMeta);
    }
    if (data.containsKey('current_index')) {
      context.handle(
        _currentIndexMeta,
        currentIndex.isAcceptableOrUnknown(
          data['current_index']!,
          _currentIndexMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {zoneId};
  @override
  LocalQueueStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalQueueStateData(
      zoneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zone_id'],
      )!,
      currentIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_index'],
      )!,
    );
  }

  @override
  $LocalQueueStateTable createAlias(String alias) {
    return $LocalQueueStateTable(attachedDatabase, alias);
  }
}

class LocalQueueStateData extends DataClass
    implements Insertable<LocalQueueStateData> {
  final String zoneId;
  final int currentIndex;
  const LocalQueueStateData({required this.zoneId, required this.currentIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['zone_id'] = Variable<String>(zoneId);
    map['current_index'] = Variable<int>(currentIndex);
    return map;
  }

  LocalQueueStateCompanion toCompanion(bool nullToAbsent) {
    return LocalQueueStateCompanion(
      zoneId: Value(zoneId),
      currentIndex: Value(currentIndex),
    );
  }

  factory LocalQueueStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalQueueStateData(
      zoneId: serializer.fromJson<String>(json['zoneId']),
      currentIndex: serializer.fromJson<int>(json['currentIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'zoneId': serializer.toJson<String>(zoneId),
      'currentIndex': serializer.toJson<int>(currentIndex),
    };
  }

  LocalQueueStateData copyWith({String? zoneId, int? currentIndex}) =>
      LocalQueueStateData(
        zoneId: zoneId ?? this.zoneId,
        currentIndex: currentIndex ?? this.currentIndex,
      );
  LocalQueueStateData copyWithCompanion(LocalQueueStateCompanion data) {
    return LocalQueueStateData(
      zoneId: data.zoneId.present ? data.zoneId.value : this.zoneId,
      currentIndex: data.currentIndex.present
          ? data.currentIndex.value
          : this.currentIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalQueueStateData(')
          ..write('zoneId: $zoneId, ')
          ..write('currentIndex: $currentIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(zoneId, currentIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalQueueStateData &&
          other.zoneId == this.zoneId &&
          other.currentIndex == this.currentIndex);
}

class LocalQueueStateCompanion extends UpdateCompanion<LocalQueueStateData> {
  final Value<String> zoneId;
  final Value<int> currentIndex;
  final Value<int> rowid;
  const LocalQueueStateCompanion({
    this.zoneId = const Value.absent(),
    this.currentIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalQueueStateCompanion.insert({
    required String zoneId,
    this.currentIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : zoneId = Value(zoneId);
  static Insertable<LocalQueueStateData> custom({
    Expression<String>? zoneId,
    Expression<int>? currentIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (zoneId != null) 'zone_id': zoneId,
      if (currentIndex != null) 'current_index': currentIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalQueueStateCompanion copyWith({
    Value<String>? zoneId,
    Value<int>? currentIndex,
    Value<int>? rowid,
  }) {
    return LocalQueueStateCompanion(
      zoneId: zoneId ?? this.zoneId,
      currentIndex: currentIndex ?? this.currentIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (zoneId.present) {
      map['zone_id'] = Variable<String>(zoneId.value);
    }
    if (currentIndex.present) {
      map['current_index'] = Variable<int>(currentIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalQueueStateCompanion(')
          ..write('zoneId: $zoneId, ')
          ..write('currentIndex: $currentIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DownloadedTracksTable extends DownloadedTracks
    with TableInfo<$DownloadedTracksTable, DownloadedTrackRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadedTracksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _fileKeyMeta = const VerificationMeta(
    'fileKey',
  );
  @override
  late final GeneratedColumn<int> fileKey = GeneratedColumn<int>(
    'file_key',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _trackJsonMeta = const VerificationMeta(
    'trackJson',
  );
  @override
  late final GeneratedColumn<String> trackJson = GeneratedColumn<String>(
    'track_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artworkPathMeta = const VerificationMeta(
    'artworkPath',
  );
  @override
  late final GeneratedColumn<String> artworkPath = GeneratedColumn<String>(
    'artwork_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _albumGroupIdMeta = const VerificationMeta(
    'albumGroupId',
  );
  @override
  late final GeneratedColumn<String> albumGroupId = GeneratedColumn<String>(
    'album_group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _albumArtistMeta = const VerificationMeta(
    'albumArtist',
  );
  @override
  late final GeneratedColumn<String> albumArtist = GeneratedColumn<String>(
    'album_artist',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _albumMeta = const VerificationMeta('album');
  @override
  late final GeneratedColumn<String> album = GeneratedColumn<String>(
    'album',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateReadableMeta = const VerificationMeta(
    'dateReadable',
  );
  @override
  late final GeneratedColumn<String> dateReadable = GeneratedColumn<String>(
    'date_readable',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discNumberMeta = const VerificationMeta(
    'discNumber',
  );
  @override
  late final GeneratedColumn<int> discNumber = GeneratedColumn<int>(
    'disc_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalDiscsMeta = const VerificationMeta(
    'totalDiscs',
  );
  @override
  late final GeneratedColumn<int> totalDiscs = GeneratedColumn<int>(
    'total_discs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackNumberMeta = const VerificationMeta(
    'trackNumber',
  );
  @override
  late final GeneratedColumn<int> trackNumber = GeneratedColumn<int>(
    'track_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeBytesMeta = const VerificationMeta(
    'fileSizeBytes',
  );
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
    'file_size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _downloadedAtMeta = const VerificationMeta(
    'downloadedAt',
  );
  @override
  late final GeneratedColumn<int> downloadedAt = GeneratedColumn<int>(
    'downloaded_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fileKey,
    trackJson,
    localPath,
    artworkPath,
    albumGroupId,
    albumArtist,
    album,
    dateReadable,
    discNumber,
    totalDiscs,
    trackNumber,
    fileSizeBytes,
    downloadedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloaded_tracks';
  @override
  VerificationContext validateIntegrity(
    Insertable<DownloadedTrackRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('file_key')) {
      context.handle(
        _fileKeyMeta,
        fileKey.isAcceptableOrUnknown(data['file_key']!, _fileKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_fileKeyMeta);
    }
    if (data.containsKey('track_json')) {
      context.handle(
        _trackJsonMeta,
        trackJson.isAcceptableOrUnknown(data['track_json']!, _trackJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_trackJsonMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('artwork_path')) {
      context.handle(
        _artworkPathMeta,
        artworkPath.isAcceptableOrUnknown(
          data['artwork_path']!,
          _artworkPathMeta,
        ),
      );
    }
    if (data.containsKey('album_group_id')) {
      context.handle(
        _albumGroupIdMeta,
        albumGroupId.isAcceptableOrUnknown(
          data['album_group_id']!,
          _albumGroupIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_albumGroupIdMeta);
    }
    if (data.containsKey('album_artist')) {
      context.handle(
        _albumArtistMeta,
        albumArtist.isAcceptableOrUnknown(
          data['album_artist']!,
          _albumArtistMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_albumArtistMeta);
    }
    if (data.containsKey('album')) {
      context.handle(
        _albumMeta,
        album.isAcceptableOrUnknown(data['album']!, _albumMeta),
      );
    } else if (isInserting) {
      context.missing(_albumMeta);
    }
    if (data.containsKey('date_readable')) {
      context.handle(
        _dateReadableMeta,
        dateReadable.isAcceptableOrUnknown(
          data['date_readable']!,
          _dateReadableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateReadableMeta);
    }
    if (data.containsKey('disc_number')) {
      context.handle(
        _discNumberMeta,
        discNumber.isAcceptableOrUnknown(data['disc_number']!, _discNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_discNumberMeta);
    }
    if (data.containsKey('total_discs')) {
      context.handle(
        _totalDiscsMeta,
        totalDiscs.isAcceptableOrUnknown(data['total_discs']!, _totalDiscsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalDiscsMeta);
    }
    if (data.containsKey('track_number')) {
      context.handle(
        _trackNumberMeta,
        trackNumber.isAcceptableOrUnknown(
          data['track_number']!,
          _trackNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trackNumberMeta);
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
        _fileSizeBytesMeta,
        fileSizeBytes.isAcceptableOrUnknown(
          data['file_size_bytes']!,
          _fileSizeBytesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fileSizeBytesMeta);
    }
    if (data.containsKey('downloaded_at')) {
      context.handle(
        _downloadedAtMeta,
        downloadedAt.isAcceptableOrUnknown(
          data['downloaded_at']!,
          _downloadedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_downloadedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DownloadedTrackRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadedTrackRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fileKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_key'],
      )!,
      trackJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}track_json'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      artworkPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artwork_path'],
      ),
      albumGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_group_id'],
      )!,
      albumArtist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album_artist'],
      )!,
      album: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album'],
      )!,
      dateReadable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_readable'],
      )!,
      discNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}disc_number'],
      )!,
      totalDiscs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_discs'],
      )!,
      trackNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_number'],
      )!,
      fileSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size_bytes'],
      )!,
      downloadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}downloaded_at'],
      )!,
    );
  }

  @override
  $DownloadedTracksTable createAlias(String alias) {
    return $DownloadedTracksTable(attachedDatabase, alias);
  }
}

class DownloadedTrackRow extends DataClass
    implements Insertable<DownloadedTrackRow> {
  final int id;
  final int fileKey;
  final String trackJson;
  final String localPath;
  final String? artworkPath;
  final String albumGroupId;
  final String albumArtist;
  final String album;
  final String dateReadable;
  final int discNumber;
  final int totalDiscs;
  final int trackNumber;
  final int fileSizeBytes;
  final int downloadedAt;
  const DownloadedTrackRow({
    required this.id,
    required this.fileKey,
    required this.trackJson,
    required this.localPath,
    this.artworkPath,
    required this.albumGroupId,
    required this.albumArtist,
    required this.album,
    required this.dateReadable,
    required this.discNumber,
    required this.totalDiscs,
    required this.trackNumber,
    required this.fileSizeBytes,
    required this.downloadedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['file_key'] = Variable<int>(fileKey);
    map['track_json'] = Variable<String>(trackJson);
    map['local_path'] = Variable<String>(localPath);
    if (!nullToAbsent || artworkPath != null) {
      map['artwork_path'] = Variable<String>(artworkPath);
    }
    map['album_group_id'] = Variable<String>(albumGroupId);
    map['album_artist'] = Variable<String>(albumArtist);
    map['album'] = Variable<String>(album);
    map['date_readable'] = Variable<String>(dateReadable);
    map['disc_number'] = Variable<int>(discNumber);
    map['total_discs'] = Variable<int>(totalDiscs);
    map['track_number'] = Variable<int>(trackNumber);
    map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    map['downloaded_at'] = Variable<int>(downloadedAt);
    return map;
  }

  DownloadedTracksCompanion toCompanion(bool nullToAbsent) {
    return DownloadedTracksCompanion(
      id: Value(id),
      fileKey: Value(fileKey),
      trackJson: Value(trackJson),
      localPath: Value(localPath),
      artworkPath: artworkPath == null && nullToAbsent
          ? const Value.absent()
          : Value(artworkPath),
      albumGroupId: Value(albumGroupId),
      albumArtist: Value(albumArtist),
      album: Value(album),
      dateReadable: Value(dateReadable),
      discNumber: Value(discNumber),
      totalDiscs: Value(totalDiscs),
      trackNumber: Value(trackNumber),
      fileSizeBytes: Value(fileSizeBytes),
      downloadedAt: Value(downloadedAt),
    );
  }

  factory DownloadedTrackRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadedTrackRow(
      id: serializer.fromJson<int>(json['id']),
      fileKey: serializer.fromJson<int>(json['fileKey']),
      trackJson: serializer.fromJson<String>(json['trackJson']),
      localPath: serializer.fromJson<String>(json['localPath']),
      artworkPath: serializer.fromJson<String?>(json['artworkPath']),
      albumGroupId: serializer.fromJson<String>(json['albumGroupId']),
      albumArtist: serializer.fromJson<String>(json['albumArtist']),
      album: serializer.fromJson<String>(json['album']),
      dateReadable: serializer.fromJson<String>(json['dateReadable']),
      discNumber: serializer.fromJson<int>(json['discNumber']),
      totalDiscs: serializer.fromJson<int>(json['totalDiscs']),
      trackNumber: serializer.fromJson<int>(json['trackNumber']),
      fileSizeBytes: serializer.fromJson<int>(json['fileSizeBytes']),
      downloadedAt: serializer.fromJson<int>(json['downloadedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fileKey': serializer.toJson<int>(fileKey),
      'trackJson': serializer.toJson<String>(trackJson),
      'localPath': serializer.toJson<String>(localPath),
      'artworkPath': serializer.toJson<String?>(artworkPath),
      'albumGroupId': serializer.toJson<String>(albumGroupId),
      'albumArtist': serializer.toJson<String>(albumArtist),
      'album': serializer.toJson<String>(album),
      'dateReadable': serializer.toJson<String>(dateReadable),
      'discNumber': serializer.toJson<int>(discNumber),
      'totalDiscs': serializer.toJson<int>(totalDiscs),
      'trackNumber': serializer.toJson<int>(trackNumber),
      'fileSizeBytes': serializer.toJson<int>(fileSizeBytes),
      'downloadedAt': serializer.toJson<int>(downloadedAt),
    };
  }

  DownloadedTrackRow copyWith({
    int? id,
    int? fileKey,
    String? trackJson,
    String? localPath,
    Value<String?> artworkPath = const Value.absent(),
    String? albumGroupId,
    String? albumArtist,
    String? album,
    String? dateReadable,
    int? discNumber,
    int? totalDiscs,
    int? trackNumber,
    int? fileSizeBytes,
    int? downloadedAt,
  }) => DownloadedTrackRow(
    id: id ?? this.id,
    fileKey: fileKey ?? this.fileKey,
    trackJson: trackJson ?? this.trackJson,
    localPath: localPath ?? this.localPath,
    artworkPath: artworkPath.present ? artworkPath.value : this.artworkPath,
    albumGroupId: albumGroupId ?? this.albumGroupId,
    albumArtist: albumArtist ?? this.albumArtist,
    album: album ?? this.album,
    dateReadable: dateReadable ?? this.dateReadable,
    discNumber: discNumber ?? this.discNumber,
    totalDiscs: totalDiscs ?? this.totalDiscs,
    trackNumber: trackNumber ?? this.trackNumber,
    fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
    downloadedAt: downloadedAt ?? this.downloadedAt,
  );
  DownloadedTrackRow copyWithCompanion(DownloadedTracksCompanion data) {
    return DownloadedTrackRow(
      id: data.id.present ? data.id.value : this.id,
      fileKey: data.fileKey.present ? data.fileKey.value : this.fileKey,
      trackJson: data.trackJson.present ? data.trackJson.value : this.trackJson,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      artworkPath: data.artworkPath.present
          ? data.artworkPath.value
          : this.artworkPath,
      albumGroupId: data.albumGroupId.present
          ? data.albumGroupId.value
          : this.albumGroupId,
      albumArtist: data.albumArtist.present
          ? data.albumArtist.value
          : this.albumArtist,
      album: data.album.present ? data.album.value : this.album,
      dateReadable: data.dateReadable.present
          ? data.dateReadable.value
          : this.dateReadable,
      discNumber: data.discNumber.present
          ? data.discNumber.value
          : this.discNumber,
      totalDiscs: data.totalDiscs.present
          ? data.totalDiscs.value
          : this.totalDiscs,
      trackNumber: data.trackNumber.present
          ? data.trackNumber.value
          : this.trackNumber,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
      downloadedAt: data.downloadedAt.present
          ? data.downloadedAt.value
          : this.downloadedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedTrackRow(')
          ..write('id: $id, ')
          ..write('fileKey: $fileKey, ')
          ..write('trackJson: $trackJson, ')
          ..write('localPath: $localPath, ')
          ..write('artworkPath: $artworkPath, ')
          ..write('albumGroupId: $albumGroupId, ')
          ..write('albumArtist: $albumArtist, ')
          ..write('album: $album, ')
          ..write('dateReadable: $dateReadable, ')
          ..write('discNumber: $discNumber, ')
          ..write('totalDiscs: $totalDiscs, ')
          ..write('trackNumber: $trackNumber, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('downloadedAt: $downloadedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fileKey,
    trackJson,
    localPath,
    artworkPath,
    albumGroupId,
    albumArtist,
    album,
    dateReadable,
    discNumber,
    totalDiscs,
    trackNumber,
    fileSizeBytes,
    downloadedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadedTrackRow &&
          other.id == this.id &&
          other.fileKey == this.fileKey &&
          other.trackJson == this.trackJson &&
          other.localPath == this.localPath &&
          other.artworkPath == this.artworkPath &&
          other.albumGroupId == this.albumGroupId &&
          other.albumArtist == this.albumArtist &&
          other.album == this.album &&
          other.dateReadable == this.dateReadable &&
          other.discNumber == this.discNumber &&
          other.totalDiscs == this.totalDiscs &&
          other.trackNumber == this.trackNumber &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.downloadedAt == this.downloadedAt);
}

class DownloadedTracksCompanion extends UpdateCompanion<DownloadedTrackRow> {
  final Value<int> id;
  final Value<int> fileKey;
  final Value<String> trackJson;
  final Value<String> localPath;
  final Value<String?> artworkPath;
  final Value<String> albumGroupId;
  final Value<String> albumArtist;
  final Value<String> album;
  final Value<String> dateReadable;
  final Value<int> discNumber;
  final Value<int> totalDiscs;
  final Value<int> trackNumber;
  final Value<int> fileSizeBytes;
  final Value<int> downloadedAt;
  const DownloadedTracksCompanion({
    this.id = const Value.absent(),
    this.fileKey = const Value.absent(),
    this.trackJson = const Value.absent(),
    this.localPath = const Value.absent(),
    this.artworkPath = const Value.absent(),
    this.albumGroupId = const Value.absent(),
    this.albumArtist = const Value.absent(),
    this.album = const Value.absent(),
    this.dateReadable = const Value.absent(),
    this.discNumber = const Value.absent(),
    this.totalDiscs = const Value.absent(),
    this.trackNumber = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.downloadedAt = const Value.absent(),
  });
  DownloadedTracksCompanion.insert({
    this.id = const Value.absent(),
    required int fileKey,
    required String trackJson,
    required String localPath,
    this.artworkPath = const Value.absent(),
    required String albumGroupId,
    required String albumArtist,
    required String album,
    required String dateReadable,
    required int discNumber,
    required int totalDiscs,
    required int trackNumber,
    required int fileSizeBytes,
    required int downloadedAt,
  }) : fileKey = Value(fileKey),
       trackJson = Value(trackJson),
       localPath = Value(localPath),
       albumGroupId = Value(albumGroupId),
       albumArtist = Value(albumArtist),
       album = Value(album),
       dateReadable = Value(dateReadable),
       discNumber = Value(discNumber),
       totalDiscs = Value(totalDiscs),
       trackNumber = Value(trackNumber),
       fileSizeBytes = Value(fileSizeBytes),
       downloadedAt = Value(downloadedAt);
  static Insertable<DownloadedTrackRow> custom({
    Expression<int>? id,
    Expression<int>? fileKey,
    Expression<String>? trackJson,
    Expression<String>? localPath,
    Expression<String>? artworkPath,
    Expression<String>? albumGroupId,
    Expression<String>? albumArtist,
    Expression<String>? album,
    Expression<String>? dateReadable,
    Expression<int>? discNumber,
    Expression<int>? totalDiscs,
    Expression<int>? trackNumber,
    Expression<int>? fileSizeBytes,
    Expression<int>? downloadedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fileKey != null) 'file_key': fileKey,
      if (trackJson != null) 'track_json': trackJson,
      if (localPath != null) 'local_path': localPath,
      if (artworkPath != null) 'artwork_path': artworkPath,
      if (albumGroupId != null) 'album_group_id': albumGroupId,
      if (albumArtist != null) 'album_artist': albumArtist,
      if (album != null) 'album': album,
      if (dateReadable != null) 'date_readable': dateReadable,
      if (discNumber != null) 'disc_number': discNumber,
      if (totalDiscs != null) 'total_discs': totalDiscs,
      if (trackNumber != null) 'track_number': trackNumber,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
    });
  }

  DownloadedTracksCompanion copyWith({
    Value<int>? id,
    Value<int>? fileKey,
    Value<String>? trackJson,
    Value<String>? localPath,
    Value<String?>? artworkPath,
    Value<String>? albumGroupId,
    Value<String>? albumArtist,
    Value<String>? album,
    Value<String>? dateReadable,
    Value<int>? discNumber,
    Value<int>? totalDiscs,
    Value<int>? trackNumber,
    Value<int>? fileSizeBytes,
    Value<int>? downloadedAt,
  }) {
    return DownloadedTracksCompanion(
      id: id ?? this.id,
      fileKey: fileKey ?? this.fileKey,
      trackJson: trackJson ?? this.trackJson,
      localPath: localPath ?? this.localPath,
      artworkPath: artworkPath ?? this.artworkPath,
      albumGroupId: albumGroupId ?? this.albumGroupId,
      albumArtist: albumArtist ?? this.albumArtist,
      album: album ?? this.album,
      dateReadable: dateReadable ?? this.dateReadable,
      discNumber: discNumber ?? this.discNumber,
      totalDiscs: totalDiscs ?? this.totalDiscs,
      trackNumber: trackNumber ?? this.trackNumber,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      downloadedAt: downloadedAt ?? this.downloadedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fileKey.present) {
      map['file_key'] = Variable<int>(fileKey.value);
    }
    if (trackJson.present) {
      map['track_json'] = Variable<String>(trackJson.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (artworkPath.present) {
      map['artwork_path'] = Variable<String>(artworkPath.value);
    }
    if (albumGroupId.present) {
      map['album_group_id'] = Variable<String>(albumGroupId.value);
    }
    if (albumArtist.present) {
      map['album_artist'] = Variable<String>(albumArtist.value);
    }
    if (album.present) {
      map['album'] = Variable<String>(album.value);
    }
    if (dateReadable.present) {
      map['date_readable'] = Variable<String>(dateReadable.value);
    }
    if (discNumber.present) {
      map['disc_number'] = Variable<int>(discNumber.value);
    }
    if (totalDiscs.present) {
      map['total_discs'] = Variable<int>(totalDiscs.value);
    }
    if (trackNumber.present) {
      map['track_number'] = Variable<int>(trackNumber.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = Variable<int>(downloadedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedTracksCompanion(')
          ..write('id: $id, ')
          ..write('fileKey: $fileKey, ')
          ..write('trackJson: $trackJson, ')
          ..write('localPath: $localPath, ')
          ..write('artworkPath: $artworkPath, ')
          ..write('albumGroupId: $albumGroupId, ')
          ..write('albumArtist: $albumArtist, ')
          ..write('album: $album, ')
          ..write('dateReadable: $dateReadable, ')
          ..write('discNumber: $discNumber, ')
          ..write('totalDiscs: $totalDiscs, ')
          ..write('trackNumber: $trackNumber, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('downloadedAt: $downloadedAt')
          ..write(')'))
        .toString();
  }
}

class $DownloadJobsTable extends DownloadJobs
    with TableInfo<$DownloadJobsTable, DownloadJobRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadJobsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _fileKeyMeta = const VerificationMeta(
    'fileKey',
  );
  @override
  late final GeneratedColumn<int> fileKey = GeneratedColumn<int>(
    'file_key',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _trackJsonMeta = const VerificationMeta(
    'trackJson',
  );
  @override
  late final GeneratedColumn<String> trackJson = GeneratedColumn<String>(
    'track_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bytesDoneMeta = const VerificationMeta(
    'bytesDone',
  );
  @override
  late final GeneratedColumn<int> bytesDone = GeneratedColumn<int>(
    'bytes_done',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bytesTotalMeta = const VerificationMeta(
    'bytesTotal',
  );
  @override
  late final GeneratedColumn<int> bytesTotal = GeneratedColumn<int>(
    'bytes_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enqueuedAtMeta = const VerificationMeta(
    'enqueuedAt',
  );
  @override
  late final GeneratedColumn<int> enqueuedAt = GeneratedColumn<int>(
    'enqueued_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fileKey,
    trackJson,
    state,
    error,
    bytesDone,
    bytesTotal,
    enqueuedAt,
    startedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'download_jobs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DownloadJobRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('file_key')) {
      context.handle(
        _fileKeyMeta,
        fileKey.isAcceptableOrUnknown(data['file_key']!, _fileKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_fileKeyMeta);
    }
    if (data.containsKey('track_json')) {
      context.handle(
        _trackJsonMeta,
        trackJson.isAcceptableOrUnknown(data['track_json']!, _trackJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_trackJsonMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    if (data.containsKey('bytes_done')) {
      context.handle(
        _bytesDoneMeta,
        bytesDone.isAcceptableOrUnknown(data['bytes_done']!, _bytesDoneMeta),
      );
    } else if (isInserting) {
      context.missing(_bytesDoneMeta);
    }
    if (data.containsKey('bytes_total')) {
      context.handle(
        _bytesTotalMeta,
        bytesTotal.isAcceptableOrUnknown(data['bytes_total']!, _bytesTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_bytesTotalMeta);
    }
    if (data.containsKey('enqueued_at')) {
      context.handle(
        _enqueuedAtMeta,
        enqueuedAt.isAcceptableOrUnknown(data['enqueued_at']!, _enqueuedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_enqueuedAtMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DownloadJobRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadJobRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fileKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_key'],
      )!,
      trackJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}track_json'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      bytesDone: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bytes_done'],
      )!,
      bytesTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bytes_total'],
      )!,
      enqueuedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}enqueued_at'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at'],
      ),
    );
  }

  @override
  $DownloadJobsTable createAlias(String alias) {
    return $DownloadJobsTable(attachedDatabase, alias);
  }
}

class DownloadJobRow extends DataClass implements Insertable<DownloadJobRow> {
  final int id;
  final int fileKey;
  final String trackJson;
  final String state;
  final String? error;
  final int bytesDone;
  final int bytesTotal;
  final int enqueuedAt;
  final int? startedAt;
  const DownloadJobRow({
    required this.id,
    required this.fileKey,
    required this.trackJson,
    required this.state,
    this.error,
    required this.bytesDone,
    required this.bytesTotal,
    required this.enqueuedAt,
    this.startedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['file_key'] = Variable<int>(fileKey);
    map['track_json'] = Variable<String>(trackJson);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    map['bytes_done'] = Variable<int>(bytesDone);
    map['bytes_total'] = Variable<int>(bytesTotal);
    map['enqueued_at'] = Variable<int>(enqueuedAt);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<int>(startedAt);
    }
    return map;
  }

  DownloadJobsCompanion toCompanion(bool nullToAbsent) {
    return DownloadJobsCompanion(
      id: Value(id),
      fileKey: Value(fileKey),
      trackJson: Value(trackJson),
      state: Value(state),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
      bytesDone: Value(bytesDone),
      bytesTotal: Value(bytesTotal),
      enqueuedAt: Value(enqueuedAt),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
    );
  }

  factory DownloadJobRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadJobRow(
      id: serializer.fromJson<int>(json['id']),
      fileKey: serializer.fromJson<int>(json['fileKey']),
      trackJson: serializer.fromJson<String>(json['trackJson']),
      state: serializer.fromJson<String>(json['state']),
      error: serializer.fromJson<String?>(json['error']),
      bytesDone: serializer.fromJson<int>(json['bytesDone']),
      bytesTotal: serializer.fromJson<int>(json['bytesTotal']),
      enqueuedAt: serializer.fromJson<int>(json['enqueuedAt']),
      startedAt: serializer.fromJson<int?>(json['startedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fileKey': serializer.toJson<int>(fileKey),
      'trackJson': serializer.toJson<String>(trackJson),
      'state': serializer.toJson<String>(state),
      'error': serializer.toJson<String?>(error),
      'bytesDone': serializer.toJson<int>(bytesDone),
      'bytesTotal': serializer.toJson<int>(bytesTotal),
      'enqueuedAt': serializer.toJson<int>(enqueuedAt),
      'startedAt': serializer.toJson<int?>(startedAt),
    };
  }

  DownloadJobRow copyWith({
    int? id,
    int? fileKey,
    String? trackJson,
    String? state,
    Value<String?> error = const Value.absent(),
    int? bytesDone,
    int? bytesTotal,
    int? enqueuedAt,
    Value<int?> startedAt = const Value.absent(),
  }) => DownloadJobRow(
    id: id ?? this.id,
    fileKey: fileKey ?? this.fileKey,
    trackJson: trackJson ?? this.trackJson,
    state: state ?? this.state,
    error: error.present ? error.value : this.error,
    bytesDone: bytesDone ?? this.bytesDone,
    bytesTotal: bytesTotal ?? this.bytesTotal,
    enqueuedAt: enqueuedAt ?? this.enqueuedAt,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
  );
  DownloadJobRow copyWithCompanion(DownloadJobsCompanion data) {
    return DownloadJobRow(
      id: data.id.present ? data.id.value : this.id,
      fileKey: data.fileKey.present ? data.fileKey.value : this.fileKey,
      trackJson: data.trackJson.present ? data.trackJson.value : this.trackJson,
      state: data.state.present ? data.state.value : this.state,
      error: data.error.present ? data.error.value : this.error,
      bytesDone: data.bytesDone.present ? data.bytesDone.value : this.bytesDone,
      bytesTotal: data.bytesTotal.present
          ? data.bytesTotal.value
          : this.bytesTotal,
      enqueuedAt: data.enqueuedAt.present
          ? data.enqueuedAt.value
          : this.enqueuedAt,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadJobRow(')
          ..write('id: $id, ')
          ..write('fileKey: $fileKey, ')
          ..write('trackJson: $trackJson, ')
          ..write('state: $state, ')
          ..write('error: $error, ')
          ..write('bytesDone: $bytesDone, ')
          ..write('bytesTotal: $bytesTotal, ')
          ..write('enqueuedAt: $enqueuedAt, ')
          ..write('startedAt: $startedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fileKey,
    trackJson,
    state,
    error,
    bytesDone,
    bytesTotal,
    enqueuedAt,
    startedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadJobRow &&
          other.id == this.id &&
          other.fileKey == this.fileKey &&
          other.trackJson == this.trackJson &&
          other.state == this.state &&
          other.error == this.error &&
          other.bytesDone == this.bytesDone &&
          other.bytesTotal == this.bytesTotal &&
          other.enqueuedAt == this.enqueuedAt &&
          other.startedAt == this.startedAt);
}

class DownloadJobsCompanion extends UpdateCompanion<DownloadJobRow> {
  final Value<int> id;
  final Value<int> fileKey;
  final Value<String> trackJson;
  final Value<String> state;
  final Value<String?> error;
  final Value<int> bytesDone;
  final Value<int> bytesTotal;
  final Value<int> enqueuedAt;
  final Value<int?> startedAt;
  const DownloadJobsCompanion({
    this.id = const Value.absent(),
    this.fileKey = const Value.absent(),
    this.trackJson = const Value.absent(),
    this.state = const Value.absent(),
    this.error = const Value.absent(),
    this.bytesDone = const Value.absent(),
    this.bytesTotal = const Value.absent(),
    this.enqueuedAt = const Value.absent(),
    this.startedAt = const Value.absent(),
  });
  DownloadJobsCompanion.insert({
    this.id = const Value.absent(),
    required int fileKey,
    required String trackJson,
    required String state,
    this.error = const Value.absent(),
    required int bytesDone,
    required int bytesTotal,
    required int enqueuedAt,
    this.startedAt = const Value.absent(),
  }) : fileKey = Value(fileKey),
       trackJson = Value(trackJson),
       state = Value(state),
       bytesDone = Value(bytesDone),
       bytesTotal = Value(bytesTotal),
       enqueuedAt = Value(enqueuedAt);
  static Insertable<DownloadJobRow> custom({
    Expression<int>? id,
    Expression<int>? fileKey,
    Expression<String>? trackJson,
    Expression<String>? state,
    Expression<String>? error,
    Expression<int>? bytesDone,
    Expression<int>? bytesTotal,
    Expression<int>? enqueuedAt,
    Expression<int>? startedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fileKey != null) 'file_key': fileKey,
      if (trackJson != null) 'track_json': trackJson,
      if (state != null) 'state': state,
      if (error != null) 'error': error,
      if (bytesDone != null) 'bytes_done': bytesDone,
      if (bytesTotal != null) 'bytes_total': bytesTotal,
      if (enqueuedAt != null) 'enqueued_at': enqueuedAt,
      if (startedAt != null) 'started_at': startedAt,
    });
  }

  DownloadJobsCompanion copyWith({
    Value<int>? id,
    Value<int>? fileKey,
    Value<String>? trackJson,
    Value<String>? state,
    Value<String?>? error,
    Value<int>? bytesDone,
    Value<int>? bytesTotal,
    Value<int>? enqueuedAt,
    Value<int?>? startedAt,
  }) {
    return DownloadJobsCompanion(
      id: id ?? this.id,
      fileKey: fileKey ?? this.fileKey,
      trackJson: trackJson ?? this.trackJson,
      state: state ?? this.state,
      error: error ?? this.error,
      bytesDone: bytesDone ?? this.bytesDone,
      bytesTotal: bytesTotal ?? this.bytesTotal,
      enqueuedAt: enqueuedAt ?? this.enqueuedAt,
      startedAt: startedAt ?? this.startedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fileKey.present) {
      map['file_key'] = Variable<int>(fileKey.value);
    }
    if (trackJson.present) {
      map['track_json'] = Variable<String>(trackJson.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (bytesDone.present) {
      map['bytes_done'] = Variable<int>(bytesDone.value);
    }
    if (bytesTotal.present) {
      map['bytes_total'] = Variable<int>(bytesTotal.value);
    }
    if (enqueuedAt.present) {
      map['enqueued_at'] = Variable<int>(enqueuedAt.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadJobsCompanion(')
          ..write('id: $id, ')
          ..write('fileKey: $fileKey, ')
          ..write('trackJson: $trackJson, ')
          ..write('state: $state, ')
          ..write('error: $error, ')
          ..write('bytesDone: $bytesDone, ')
          ..write('bytesTotal: $bytesTotal, ')
          ..write('enqueuedAt: $enqueuedAt, ')
          ..write('startedAt: $startedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SavedServersTable savedServers = $SavedServersTable(this);
  late final $FavoritesTable favorites = $FavoritesTable(this);
  late final $LocalQueueTracksTable localQueueTracks = $LocalQueueTracksTable(
    this,
  );
  late final $LocalQueueStateTable localQueueState = $LocalQueueStateTable(
    this,
  );
  late final $DownloadedTracksTable downloadedTracks = $DownloadedTracksTable(
    this,
  );
  late final $DownloadJobsTable downloadJobs = $DownloadJobsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    savedServers,
    favorites,
    localQueueTracks,
    localQueueState,
    downloadedTracks,
    downloadJobs,
  ];
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
      Value<bool> useSsl,
      Value<int> sslPort,
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
      Value<bool> useSsl,
      Value<int> sslPort,
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

  ColumnFilters<bool> get useSsl => $composableBuilder(
    column: $table.useSsl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sslPort => $composableBuilder(
    column: $table.sslPort,
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

  ColumnOrderings<bool> get useSsl => $composableBuilder(
    column: $table.useSsl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sslPort => $composableBuilder(
    column: $table.sslPort,
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

  GeneratedColumn<bool> get useSsl =>
      $composableBuilder(column: $table.useSsl, builder: (column) => column);

  GeneratedColumn<int> get sslPort =>
      $composableBuilder(column: $table.sslPort, builder: (column) => column);
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
                Value<bool> useSsl = const Value.absent(),
                Value<int> sslPort = const Value.absent(),
              }) => SavedServersCompanion(
                id: id,
                host: host,
                port: port,
                username: username,
                passwordKey: passwordKey,
                friendlyName: friendlyName,
                lastUsedAt: lastUsedAt,
                authToken: authToken,
                useSsl: useSsl,
                sslPort: sslPort,
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
                Value<bool> useSsl = const Value.absent(),
                Value<int> sslPort = const Value.absent(),
              }) => SavedServersCompanion.insert(
                id: id,
                host: host,
                port: port,
                username: username,
                passwordKey: passwordKey,
                friendlyName: friendlyName,
                lastUsedAt: lastUsedAt,
                authToken: authToken,
                useSsl: useSsl,
                sslPort: sslPort,
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
typedef $$FavoritesTableCreateCompanionBuilder =
    FavoritesCompanion Function({
      Value<int> id,
      required String type,
      required String identifier,
      required String displayName,
      required int addedAt,
    });
typedef $$FavoritesTableUpdateCompanionBuilder =
    FavoritesCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<String> identifier,
      Value<String> displayName,
      Value<int> addedAt,
    });

class $$FavoritesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FavoritesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FavoritesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$FavoritesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoritesTable,
          Favorite,
          $$FavoritesTableFilterComposer,
          $$FavoritesTableOrderingComposer,
          $$FavoritesTableAnnotationComposer,
          $$FavoritesTableCreateCompanionBuilder,
          $$FavoritesTableUpdateCompanionBuilder,
          (Favorite, BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>),
          Favorite,
          PrefetchHooks Function()
        > {
  $$FavoritesTableTableManager(_$AppDatabase db, $FavoritesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> identifier = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<int> addedAt = const Value.absent(),
              }) => FavoritesCompanion(
                id: id,
                type: type,
                identifier: identifier,
                displayName: displayName,
                addedAt: addedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required String identifier,
                required String displayName,
                required int addedAt,
              }) => FavoritesCompanion.insert(
                id: id,
                type: type,
                identifier: identifier,
                displayName: displayName,
                addedAt: addedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoritesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoritesTable,
      Favorite,
      $$FavoritesTableFilterComposer,
      $$FavoritesTableOrderingComposer,
      $$FavoritesTableAnnotationComposer,
      $$FavoritesTableCreateCompanionBuilder,
      $$FavoritesTableUpdateCompanionBuilder,
      (Favorite, BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>),
      Favorite,
      PrefetchHooks Function()
    >;
typedef $$LocalQueueTracksTableCreateCompanionBuilder =
    LocalQueueTracksCompanion Function({
      Value<int> id,
      Value<String> zoneId,
      required int fileKey,
      required String trackJson,
      required int position,
    });
typedef $$LocalQueueTracksTableUpdateCompanionBuilder =
    LocalQueueTracksCompanion Function({
      Value<int> id,
      Value<String> zoneId,
      Value<int> fileKey,
      Value<String> trackJson,
      Value<int> position,
    });

class $$LocalQueueTracksTableFilterComposer
    extends Composer<_$AppDatabase, $LocalQueueTracksTable> {
  $$LocalQueueTracksTableFilterComposer({
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

  ColumnFilters<String> get zoneId => $composableBuilder(
    column: $table.zoneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileKey => $composableBuilder(
    column: $table.fileKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackJson => $composableBuilder(
    column: $table.trackJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalQueueTracksTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalQueueTracksTable> {
  $$LocalQueueTracksTableOrderingComposer({
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

  ColumnOrderings<String> get zoneId => $composableBuilder(
    column: $table.zoneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileKey => $composableBuilder(
    column: $table.fileKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackJson => $composableBuilder(
    column: $table.trackJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalQueueTracksTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalQueueTracksTable> {
  $$LocalQueueTracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get zoneId =>
      $composableBuilder(column: $table.zoneId, builder: (column) => column);

  GeneratedColumn<int> get fileKey =>
      $composableBuilder(column: $table.fileKey, builder: (column) => column);

  GeneratedColumn<String> get trackJson =>
      $composableBuilder(column: $table.trackJson, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$LocalQueueTracksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalQueueTracksTable,
          LocalQueueTrack,
          $$LocalQueueTracksTableFilterComposer,
          $$LocalQueueTracksTableOrderingComposer,
          $$LocalQueueTracksTableAnnotationComposer,
          $$LocalQueueTracksTableCreateCompanionBuilder,
          $$LocalQueueTracksTableUpdateCompanionBuilder,
          (
            LocalQueueTrack,
            BaseReferences<
              _$AppDatabase,
              $LocalQueueTracksTable,
              LocalQueueTrack
            >,
          ),
          LocalQueueTrack,
          PrefetchHooks Function()
        > {
  $$LocalQueueTracksTableTableManager(
    _$AppDatabase db,
    $LocalQueueTracksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalQueueTracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalQueueTracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalQueueTracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> zoneId = const Value.absent(),
                Value<int> fileKey = const Value.absent(),
                Value<String> trackJson = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => LocalQueueTracksCompanion(
                id: id,
                zoneId: zoneId,
                fileKey: fileKey,
                trackJson: trackJson,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> zoneId = const Value.absent(),
                required int fileKey,
                required String trackJson,
                required int position,
              }) => LocalQueueTracksCompanion.insert(
                id: id,
                zoneId: zoneId,
                fileKey: fileKey,
                trackJson: trackJson,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalQueueTracksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalQueueTracksTable,
      LocalQueueTrack,
      $$LocalQueueTracksTableFilterComposer,
      $$LocalQueueTracksTableOrderingComposer,
      $$LocalQueueTracksTableAnnotationComposer,
      $$LocalQueueTracksTableCreateCompanionBuilder,
      $$LocalQueueTracksTableUpdateCompanionBuilder,
      (
        LocalQueueTrack,
        BaseReferences<_$AppDatabase, $LocalQueueTracksTable, LocalQueueTrack>,
      ),
      LocalQueueTrack,
      PrefetchHooks Function()
    >;
typedef $$LocalQueueStateTableCreateCompanionBuilder =
    LocalQueueStateCompanion Function({
      required String zoneId,
      Value<int> currentIndex,
      Value<int> rowid,
    });
typedef $$LocalQueueStateTableUpdateCompanionBuilder =
    LocalQueueStateCompanion Function({
      Value<String> zoneId,
      Value<int> currentIndex,
      Value<int> rowid,
    });

class $$LocalQueueStateTableFilterComposer
    extends Composer<_$AppDatabase, $LocalQueueStateTable> {
  $$LocalQueueStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get zoneId => $composableBuilder(
    column: $table.zoneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalQueueStateTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalQueueStateTable> {
  $$LocalQueueStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get zoneId => $composableBuilder(
    column: $table.zoneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalQueueStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalQueueStateTable> {
  $$LocalQueueStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get zoneId =>
      $composableBuilder(column: $table.zoneId, builder: (column) => column);

  GeneratedColumn<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => column,
  );
}

class $$LocalQueueStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalQueueStateTable,
          LocalQueueStateData,
          $$LocalQueueStateTableFilterComposer,
          $$LocalQueueStateTableOrderingComposer,
          $$LocalQueueStateTableAnnotationComposer,
          $$LocalQueueStateTableCreateCompanionBuilder,
          $$LocalQueueStateTableUpdateCompanionBuilder,
          (
            LocalQueueStateData,
            BaseReferences<
              _$AppDatabase,
              $LocalQueueStateTable,
              LocalQueueStateData
            >,
          ),
          LocalQueueStateData,
          PrefetchHooks Function()
        > {
  $$LocalQueueStateTableTableManager(
    _$AppDatabase db,
    $LocalQueueStateTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalQueueStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalQueueStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalQueueStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> zoneId = const Value.absent(),
                Value<int> currentIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalQueueStateCompanion(
                zoneId: zoneId,
                currentIndex: currentIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String zoneId,
                Value<int> currentIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalQueueStateCompanion.insert(
                zoneId: zoneId,
                currentIndex: currentIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalQueueStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalQueueStateTable,
      LocalQueueStateData,
      $$LocalQueueStateTableFilterComposer,
      $$LocalQueueStateTableOrderingComposer,
      $$LocalQueueStateTableAnnotationComposer,
      $$LocalQueueStateTableCreateCompanionBuilder,
      $$LocalQueueStateTableUpdateCompanionBuilder,
      (
        LocalQueueStateData,
        BaseReferences<
          _$AppDatabase,
          $LocalQueueStateTable,
          LocalQueueStateData
        >,
      ),
      LocalQueueStateData,
      PrefetchHooks Function()
    >;
typedef $$DownloadedTracksTableCreateCompanionBuilder =
    DownloadedTracksCompanion Function({
      Value<int> id,
      required int fileKey,
      required String trackJson,
      required String localPath,
      Value<String?> artworkPath,
      required String albumGroupId,
      required String albumArtist,
      required String album,
      required String dateReadable,
      required int discNumber,
      required int totalDiscs,
      required int trackNumber,
      required int fileSizeBytes,
      required int downloadedAt,
    });
typedef $$DownloadedTracksTableUpdateCompanionBuilder =
    DownloadedTracksCompanion Function({
      Value<int> id,
      Value<int> fileKey,
      Value<String> trackJson,
      Value<String> localPath,
      Value<String?> artworkPath,
      Value<String> albumGroupId,
      Value<String> albumArtist,
      Value<String> album,
      Value<String> dateReadable,
      Value<int> discNumber,
      Value<int> totalDiscs,
      Value<int> trackNumber,
      Value<int> fileSizeBytes,
      Value<int> downloadedAt,
    });

class $$DownloadedTracksTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadedTracksTable> {
  $$DownloadedTracksTableFilterComposer({
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

  ColumnFilters<int> get fileKey => $composableBuilder(
    column: $table.fileKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackJson => $composableBuilder(
    column: $table.trackJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artworkPath => $composableBuilder(
    column: $table.artworkPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumGroupId => $composableBuilder(
    column: $table.albumGroupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumArtist => $composableBuilder(
    column: $table.albumArtist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get album => $composableBuilder(
    column: $table.album,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateReadable => $composableBuilder(
    column: $table.dateReadable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discNumber => $composableBuilder(
    column: $table.discNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDiscs => $composableBuilder(
    column: $table.totalDiscs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trackNumber => $composableBuilder(
    column: $table.trackNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DownloadedTracksTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadedTracksTable> {
  $$DownloadedTracksTableOrderingComposer({
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

  ColumnOrderings<int> get fileKey => $composableBuilder(
    column: $table.fileKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackJson => $composableBuilder(
    column: $table.trackJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artworkPath => $composableBuilder(
    column: $table.artworkPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumGroupId => $composableBuilder(
    column: $table.albumGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumArtist => $composableBuilder(
    column: $table.albumArtist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get album => $composableBuilder(
    column: $table.album,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateReadable => $composableBuilder(
    column: $table.dateReadable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discNumber => $composableBuilder(
    column: $table.discNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDiscs => $composableBuilder(
    column: $table.totalDiscs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trackNumber => $composableBuilder(
    column: $table.trackNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DownloadedTracksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadedTracksTable> {
  $$DownloadedTracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get fileKey =>
      $composableBuilder(column: $table.fileKey, builder: (column) => column);

  GeneratedColumn<String> get trackJson =>
      $composableBuilder(column: $table.trackJson, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get artworkPath => $composableBuilder(
    column: $table.artworkPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get albumGroupId => $composableBuilder(
    column: $table.albumGroupId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get albumArtist => $composableBuilder(
    column: $table.albumArtist,
    builder: (column) => column,
  );

  GeneratedColumn<String> get album =>
      $composableBuilder(column: $table.album, builder: (column) => column);

  GeneratedColumn<String> get dateReadable => $composableBuilder(
    column: $table.dateReadable,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discNumber => $composableBuilder(
    column: $table.discNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalDiscs => $composableBuilder(
    column: $table.totalDiscs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get trackNumber => $composableBuilder(
    column: $table.trackNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => column,
  );
}

class $$DownloadedTracksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DownloadedTracksTable,
          DownloadedTrackRow,
          $$DownloadedTracksTableFilterComposer,
          $$DownloadedTracksTableOrderingComposer,
          $$DownloadedTracksTableAnnotationComposer,
          $$DownloadedTracksTableCreateCompanionBuilder,
          $$DownloadedTracksTableUpdateCompanionBuilder,
          (
            DownloadedTrackRow,
            BaseReferences<
              _$AppDatabase,
              $DownloadedTracksTable,
              DownloadedTrackRow
            >,
          ),
          DownloadedTrackRow,
          PrefetchHooks Function()
        > {
  $$DownloadedTracksTableTableManager(
    _$AppDatabase db,
    $DownloadedTracksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadedTracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadedTracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadedTracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> fileKey = const Value.absent(),
                Value<String> trackJson = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String?> artworkPath = const Value.absent(),
                Value<String> albumGroupId = const Value.absent(),
                Value<String> albumArtist = const Value.absent(),
                Value<String> album = const Value.absent(),
                Value<String> dateReadable = const Value.absent(),
                Value<int> discNumber = const Value.absent(),
                Value<int> totalDiscs = const Value.absent(),
                Value<int> trackNumber = const Value.absent(),
                Value<int> fileSizeBytes = const Value.absent(),
                Value<int> downloadedAt = const Value.absent(),
              }) => DownloadedTracksCompanion(
                id: id,
                fileKey: fileKey,
                trackJson: trackJson,
                localPath: localPath,
                artworkPath: artworkPath,
                albumGroupId: albumGroupId,
                albumArtist: albumArtist,
                album: album,
                dateReadable: dateReadable,
                discNumber: discNumber,
                totalDiscs: totalDiscs,
                trackNumber: trackNumber,
                fileSizeBytes: fileSizeBytes,
                downloadedAt: downloadedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int fileKey,
                required String trackJson,
                required String localPath,
                Value<String?> artworkPath = const Value.absent(),
                required String albumGroupId,
                required String albumArtist,
                required String album,
                required String dateReadable,
                required int discNumber,
                required int totalDiscs,
                required int trackNumber,
                required int fileSizeBytes,
                required int downloadedAt,
              }) => DownloadedTracksCompanion.insert(
                id: id,
                fileKey: fileKey,
                trackJson: trackJson,
                localPath: localPath,
                artworkPath: artworkPath,
                albumGroupId: albumGroupId,
                albumArtist: albumArtist,
                album: album,
                dateReadable: dateReadable,
                discNumber: discNumber,
                totalDiscs: totalDiscs,
                trackNumber: trackNumber,
                fileSizeBytes: fileSizeBytes,
                downloadedAt: downloadedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DownloadedTracksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DownloadedTracksTable,
      DownloadedTrackRow,
      $$DownloadedTracksTableFilterComposer,
      $$DownloadedTracksTableOrderingComposer,
      $$DownloadedTracksTableAnnotationComposer,
      $$DownloadedTracksTableCreateCompanionBuilder,
      $$DownloadedTracksTableUpdateCompanionBuilder,
      (
        DownloadedTrackRow,
        BaseReferences<
          _$AppDatabase,
          $DownloadedTracksTable,
          DownloadedTrackRow
        >,
      ),
      DownloadedTrackRow,
      PrefetchHooks Function()
    >;
typedef $$DownloadJobsTableCreateCompanionBuilder =
    DownloadJobsCompanion Function({
      Value<int> id,
      required int fileKey,
      required String trackJson,
      required String state,
      Value<String?> error,
      required int bytesDone,
      required int bytesTotal,
      required int enqueuedAt,
      Value<int?> startedAt,
    });
typedef $$DownloadJobsTableUpdateCompanionBuilder =
    DownloadJobsCompanion Function({
      Value<int> id,
      Value<int> fileKey,
      Value<String> trackJson,
      Value<String> state,
      Value<String?> error,
      Value<int> bytesDone,
      Value<int> bytesTotal,
      Value<int> enqueuedAt,
      Value<int?> startedAt,
    });

class $$DownloadJobsTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadJobsTable> {
  $$DownloadJobsTableFilterComposer({
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

  ColumnFilters<int> get fileKey => $composableBuilder(
    column: $table.fileKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackJson => $composableBuilder(
    column: $table.trackJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bytesDone => $composableBuilder(
    column: $table.bytesDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bytesTotal => $composableBuilder(
    column: $table.bytesTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get enqueuedAt => $composableBuilder(
    column: $table.enqueuedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DownloadJobsTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadJobsTable> {
  $$DownloadJobsTableOrderingComposer({
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

  ColumnOrderings<int> get fileKey => $composableBuilder(
    column: $table.fileKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackJson => $composableBuilder(
    column: $table.trackJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bytesDone => $composableBuilder(
    column: $table.bytesDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bytesTotal => $composableBuilder(
    column: $table.bytesTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get enqueuedAt => $composableBuilder(
    column: $table.enqueuedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DownloadJobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadJobsTable> {
  $$DownloadJobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get fileKey =>
      $composableBuilder(column: $table.fileKey, builder: (column) => column);

  GeneratedColumn<String> get trackJson =>
      $composableBuilder(column: $table.trackJson, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<int> get bytesDone =>
      $composableBuilder(column: $table.bytesDone, builder: (column) => column);

  GeneratedColumn<int> get bytesTotal => $composableBuilder(
    column: $table.bytesTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get enqueuedAt => $composableBuilder(
    column: $table.enqueuedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);
}

class $$DownloadJobsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DownloadJobsTable,
          DownloadJobRow,
          $$DownloadJobsTableFilterComposer,
          $$DownloadJobsTableOrderingComposer,
          $$DownloadJobsTableAnnotationComposer,
          $$DownloadJobsTableCreateCompanionBuilder,
          $$DownloadJobsTableUpdateCompanionBuilder,
          (
            DownloadJobRow,
            BaseReferences<_$AppDatabase, $DownloadJobsTable, DownloadJobRow>,
          ),
          DownloadJobRow,
          PrefetchHooks Function()
        > {
  $$DownloadJobsTableTableManager(_$AppDatabase db, $DownloadJobsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadJobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadJobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadJobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> fileKey = const Value.absent(),
                Value<String> trackJson = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<int> bytesDone = const Value.absent(),
                Value<int> bytesTotal = const Value.absent(),
                Value<int> enqueuedAt = const Value.absent(),
                Value<int?> startedAt = const Value.absent(),
              }) => DownloadJobsCompanion(
                id: id,
                fileKey: fileKey,
                trackJson: trackJson,
                state: state,
                error: error,
                bytesDone: bytesDone,
                bytesTotal: bytesTotal,
                enqueuedAt: enqueuedAt,
                startedAt: startedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int fileKey,
                required String trackJson,
                required String state,
                Value<String?> error = const Value.absent(),
                required int bytesDone,
                required int bytesTotal,
                required int enqueuedAt,
                Value<int?> startedAt = const Value.absent(),
              }) => DownloadJobsCompanion.insert(
                id: id,
                fileKey: fileKey,
                trackJson: trackJson,
                state: state,
                error: error,
                bytesDone: bytesDone,
                bytesTotal: bytesTotal,
                enqueuedAt: enqueuedAt,
                startedAt: startedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DownloadJobsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DownloadJobsTable,
      DownloadJobRow,
      $$DownloadJobsTableFilterComposer,
      $$DownloadJobsTableOrderingComposer,
      $$DownloadJobsTableAnnotationComposer,
      $$DownloadJobsTableCreateCompanionBuilder,
      $$DownloadJobsTableUpdateCompanionBuilder,
      (
        DownloadJobRow,
        BaseReferences<_$AppDatabase, $DownloadJobsTable, DownloadJobRow>,
      ),
      DownloadJobRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SavedServersTableTableManager get savedServers =>
      $$SavedServersTableTableManager(_db, _db.savedServers);
  $$FavoritesTableTableManager get favorites =>
      $$FavoritesTableTableManager(_db, _db.favorites);
  $$LocalQueueTracksTableTableManager get localQueueTracks =>
      $$LocalQueueTracksTableTableManager(_db, _db.localQueueTracks);
  $$LocalQueueStateTableTableManager get localQueueState =>
      $$LocalQueueStateTableTableManager(_db, _db.localQueueState);
  $$DownloadedTracksTableTableManager get downloadedTracks =>
      $$DownloadedTracksTableTableManager(_db, _db.downloadedTracks);
  $$DownloadJobsTableTableManager get downloadJobs =>
      $$DownloadJobsTableTableManager(_db, _db.downloadJobs);
}
