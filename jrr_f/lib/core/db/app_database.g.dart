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
  List<GeneratedColumn> get $columns => [id, fileKey, trackJson, position];
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
  final int fileKey;
  final String trackJson;
  final int position;
  const LocalQueueTrack({
    required this.id,
    required this.fileKey,
    required this.trackJson,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['file_key'] = Variable<int>(fileKey);
    map['track_json'] = Variable<String>(trackJson);
    map['position'] = Variable<int>(position);
    return map;
  }

  LocalQueueTracksCompanion toCompanion(bool nullToAbsent) {
    return LocalQueueTracksCompanion(
      id: Value(id),
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
      'fileKey': serializer.toJson<int>(fileKey),
      'trackJson': serializer.toJson<String>(trackJson),
      'position': serializer.toJson<int>(position),
    };
  }

  LocalQueueTrack copyWith({
    int? id,
    int? fileKey,
    String? trackJson,
    int? position,
  }) => LocalQueueTrack(
    id: id ?? this.id,
    fileKey: fileKey ?? this.fileKey,
    trackJson: trackJson ?? this.trackJson,
    position: position ?? this.position,
  );
  LocalQueueTrack copyWithCompanion(LocalQueueTracksCompanion data) {
    return LocalQueueTrack(
      id: data.id.present ? data.id.value : this.id,
      fileKey: data.fileKey.present ? data.fileKey.value : this.fileKey,
      trackJson: data.trackJson.present ? data.trackJson.value : this.trackJson,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalQueueTrack(')
          ..write('id: $id, ')
          ..write('fileKey: $fileKey, ')
          ..write('trackJson: $trackJson, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fileKey, trackJson, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalQueueTrack &&
          other.id == this.id &&
          other.fileKey == this.fileKey &&
          other.trackJson == this.trackJson &&
          other.position == this.position);
}

class LocalQueueTracksCompanion extends UpdateCompanion<LocalQueueTrack> {
  final Value<int> id;
  final Value<int> fileKey;
  final Value<String> trackJson;
  final Value<int> position;
  const LocalQueueTracksCompanion({
    this.id = const Value.absent(),
    this.fileKey = const Value.absent(),
    this.trackJson = const Value.absent(),
    this.position = const Value.absent(),
  });
  LocalQueueTracksCompanion.insert({
    this.id = const Value.absent(),
    required int fileKey,
    required String trackJson,
    required int position,
  }) : fileKey = Value(fileKey),
       trackJson = Value(trackJson),
       position = Value(position);
  static Insertable<LocalQueueTrack> custom({
    Expression<int>? id,
    Expression<int>? fileKey,
    Expression<String>? trackJson,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fileKey != null) 'file_key': fileKey,
      if (trackJson != null) 'track_json': trackJson,
      if (position != null) 'position': position,
    });
  }

  LocalQueueTracksCompanion copyWith({
    Value<int>? id,
    Value<int>? fileKey,
    Value<String>? trackJson,
    Value<int>? position,
  }) {
    return LocalQueueTracksCompanion(
      id: id ?? this.id,
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
  List<GeneratedColumn> get $columns => [id, currentIndex];
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
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalQueueStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalQueueStateData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
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
  final int id;
  final int currentIndex;
  const LocalQueueStateData({required this.id, required this.currentIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['current_index'] = Variable<int>(currentIndex);
    return map;
  }

  LocalQueueStateCompanion toCompanion(bool nullToAbsent) {
    return LocalQueueStateCompanion(
      id: Value(id),
      currentIndex: Value(currentIndex),
    );
  }

  factory LocalQueueStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalQueueStateData(
      id: serializer.fromJson<int>(json['id']),
      currentIndex: serializer.fromJson<int>(json['currentIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currentIndex': serializer.toJson<int>(currentIndex),
    };
  }

  LocalQueueStateData copyWith({int? id, int? currentIndex}) =>
      LocalQueueStateData(
        id: id ?? this.id,
        currentIndex: currentIndex ?? this.currentIndex,
      );
  LocalQueueStateData copyWithCompanion(LocalQueueStateCompanion data) {
    return LocalQueueStateData(
      id: data.id.present ? data.id.value : this.id,
      currentIndex: data.currentIndex.present
          ? data.currentIndex.value
          : this.currentIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalQueueStateData(')
          ..write('id: $id, ')
          ..write('currentIndex: $currentIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, currentIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalQueueStateData &&
          other.id == this.id &&
          other.currentIndex == this.currentIndex);
}

class LocalQueueStateCompanion extends UpdateCompanion<LocalQueueStateData> {
  final Value<int> id;
  final Value<int> currentIndex;
  const LocalQueueStateCompanion({
    this.id = const Value.absent(),
    this.currentIndex = const Value.absent(),
  });
  LocalQueueStateCompanion.insert({
    this.id = const Value.absent(),
    this.currentIndex = const Value.absent(),
  });
  static Insertable<LocalQueueStateData> custom({
    Expression<int>? id,
    Expression<int>? currentIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentIndex != null) 'current_index': currentIndex,
    });
  }

  LocalQueueStateCompanion copyWith({
    Value<int>? id,
    Value<int>? currentIndex,
  }) {
    return LocalQueueStateCompanion(
      id: id ?? this.id,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currentIndex.present) {
      map['current_index'] = Variable<int>(currentIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalQueueStateCompanion(')
          ..write('id: $id, ')
          ..write('currentIndex: $currentIndex')
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
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    savedServers,
    favorites,
    localQueueTracks,
    localQueueState,
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
      required int fileKey,
      required String trackJson,
      required int position,
    });
typedef $$LocalQueueTracksTableUpdateCompanionBuilder =
    LocalQueueTracksCompanion Function({
      Value<int> id,
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
                Value<int> fileKey = const Value.absent(),
                Value<String> trackJson = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => LocalQueueTracksCompanion(
                id: id,
                fileKey: fileKey,
                trackJson: trackJson,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int fileKey,
                required String trackJson,
                required int position,
              }) => LocalQueueTracksCompanion.insert(
                id: id,
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
    LocalQueueStateCompanion Function({Value<int> id, Value<int> currentIndex});
typedef $$LocalQueueStateTableUpdateCompanionBuilder =
    LocalQueueStateCompanion Function({Value<int> id, Value<int> currentIndex});

class $$LocalQueueStateTableFilterComposer
    extends Composer<_$AppDatabase, $LocalQueueStateTable> {
  $$LocalQueueStateTableFilterComposer({
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
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
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
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

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
                Value<int> id = const Value.absent(),
                Value<int> currentIndex = const Value.absent(),
              }) =>
                  LocalQueueStateCompanion(id: id, currentIndex: currentIndex),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> currentIndex = const Value.absent(),
              }) => LocalQueueStateCompanion.insert(
                id: id,
                currentIndex: currentIndex,
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
}
