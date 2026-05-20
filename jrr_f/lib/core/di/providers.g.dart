// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(talker)
final talkerProvider = TalkerProvider._();

final class TalkerProvider extends $FunctionalProvider<Talker, Talker, Talker>
    with $Provider<Talker> {
  TalkerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'talkerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$talkerHash();

  @$internal
  @override
  $ProviderElement<Talker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Talker create(Ref ref) {
    return talker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Talker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Talker>(value),
    );
  }
}

String _$talkerHash() => r'de964e6a098fb683a82bf8f48df47c274e878a60';

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'5f667d1837f90bd9121b6f8f4fabef9df68e20d9';

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'98a09c6cfd43966155dfbdb0787fa18c85438e13';

@ProviderFor(flutterSecureStorage)
final flutterSecureStorageProvider = FlutterSecureStorageProvider._();

final class FlutterSecureStorageProvider
    extends
        $FunctionalProvider<
          FlutterSecureStorage,
          FlutterSecureStorage,
          FlutterSecureStorage
        >
    with $Provider<FlutterSecureStorage> {
  FlutterSecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'flutterSecureStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$flutterSecureStorageHash();

  @$internal
  @override
  $ProviderElement<FlutterSecureStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FlutterSecureStorage create(Ref ref) {
    return flutterSecureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlutterSecureStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlutterSecureStorage>(value),
    );
  }
}

String _$flutterSecureStorageHash() =>
    r'9dabaf04e2265a8783e07e01e36c360bb77ca3d3';

@ProviderFor(mcwsXmlParser)
final mcwsXmlParserProvider = McwsXmlParserProvider._();

final class McwsXmlParserProvider
    extends $FunctionalProvider<McwsXmlParser, McwsXmlParser, McwsXmlParser>
    with $Provider<McwsXmlParser> {
  McwsXmlParserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mcwsXmlParserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mcwsXmlParserHash();

  @$internal
  @override
  $ProviderElement<McwsXmlParser> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  McwsXmlParser create(Ref ref) {
    return mcwsXmlParser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(McwsXmlParser value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<McwsXmlParser>(value),
    );
  }
}

String _$mcwsXmlParserHash() => r'5ba452943346d15d2091d4ea3b1ae718cac99c48';

/// Reactive accessor to the active session's [McwsClient]. Invalidates
/// itself whenever the connection repository swaps the client (connect,
/// restore, clearSession), so repos that read this lazily always see the
/// latest instance. Throws when no session is bound — callers should gate
/// MCWS calls on the active zone not being a virtual one.

@ProviderFor(mcwsClient)
final mcwsClientProvider = McwsClientProvider._();

/// Reactive accessor to the active session's [McwsClient]. Invalidates
/// itself whenever the connection repository swaps the client (connect,
/// restore, clearSession), so repos that read this lazily always see the
/// latest instance. Throws when no session is bound — callers should gate
/// MCWS calls on the active zone not being a virtual one.

final class McwsClientProvider
    extends $FunctionalProvider<McwsClient, McwsClient, McwsClient>
    with $Provider<McwsClient> {
  /// Reactive accessor to the active session's [McwsClient]. Invalidates
  /// itself whenever the connection repository swaps the client (connect,
  /// restore, clearSession), so repos that read this lazily always see the
  /// latest instance. Throws when no session is bound — callers should gate
  /// MCWS calls on the active zone not being a virtual one.
  McwsClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mcwsClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mcwsClientHash();

  @$internal
  @override
  $ProviderElement<McwsClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  McwsClient create(Ref ref) {
    return mcwsClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(McwsClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<McwsClient>(value),
    );
  }
}

String _$mcwsClientHash() => r'86952f92bd0f7e30e86795527e0cba08cf2169eb';

@ProviderFor(connectionRepository)
final connectionRepositoryProvider = ConnectionRepositoryProvider._();

final class ConnectionRepositoryProvider
    extends
        $FunctionalProvider<
          ConnectionRepository,
          ConnectionRepository,
          ConnectionRepository
        >
    with $Provider<ConnectionRepository> {
  ConnectionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectionRepositoryHash();

  @$internal
  @override
  $ProviderElement<ConnectionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConnectionRepository create(Ref ref) {
    return connectionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConnectionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConnectionRepository>(value),
    );
  }
}

String _$connectionRepositoryHash() =>
    r'b78acfb562781cf5ba5a420a81fad09ef3ffb414';

@ProviderFor(playerRepository)
final playerRepositoryProvider = PlayerRepositoryProvider._();

final class PlayerRepositoryProvider
    extends
        $FunctionalProvider<
          PlayerRepository,
          PlayerRepository,
          PlayerRepository
        >
    with $Provider<PlayerRepository> {
  PlayerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlayerRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PlayerRepository create(Ref ref) {
    return playerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlayerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlayerRepository>(value),
    );
  }
}

String _$playerRepositoryHash() => r'050df0e1aa5a2f4e0d103e5577b7df83fc5df3e1';

@ProviderFor(zoneRepository)
final zoneRepositoryProvider = ZoneRepositoryProvider._();

final class ZoneRepositoryProvider
    extends $FunctionalProvider<ZoneRepository, ZoneRepository, ZoneRepository>
    with $Provider<ZoneRepository> {
  ZoneRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zoneRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zoneRepositoryHash();

  @$internal
  @override
  $ProviderElement<ZoneRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ZoneRepository create(Ref ref) {
    return zoneRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ZoneRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ZoneRepository>(value),
    );
  }
}

String _$zoneRepositoryHash() => r'a3c9f04dad1f5d6afed15c71aef069ee2835c02b';

@ProviderFor(queueRepository)
final queueRepositoryProvider = QueueRepositoryProvider._();

final class QueueRepositoryProvider
    extends
        $FunctionalProvider<QueueRepository, QueueRepository, QueueRepository>
    with $Provider<QueueRepository> {
  QueueRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queueRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queueRepositoryHash();

  @$internal
  @override
  $ProviderElement<QueueRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QueueRepository create(Ref ref) {
    return queueRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QueueRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QueueRepository>(value),
    );
  }
}

String _$queueRepositoryHash() => r'f57a07aa04193c781469e241a4cc8d08fc35346a';

@ProviderFor(localQueueRepository)
final localQueueRepositoryProvider = LocalQueueRepositoryProvider._();

final class LocalQueueRepositoryProvider
    extends
        $FunctionalProvider<
          LocalQueueRepository,
          LocalQueueRepository,
          LocalQueueRepository
        >
    with $Provider<LocalQueueRepository> {
  LocalQueueRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localQueueRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localQueueRepositoryHash();

  @$internal
  @override
  $ProviderElement<LocalQueueRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalQueueRepository create(Ref ref) {
    return localQueueRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalQueueRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalQueueRepository>(value),
    );
  }
}

String _$localQueueRepositoryHash() =>
    r'ecda4f9c954f7c4c089d09899e20421ffcb53e8a';

@ProviderFor(libraryRepository)
final libraryRepositoryProvider = LibraryRepositoryProvider._();

final class LibraryRepositoryProvider
    extends
        $FunctionalProvider<
          LibraryRepository,
          LibraryRepository,
          LibraryRepository
        >
    with $Provider<LibraryRepository> {
  LibraryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryRepositoryHash();

  @$internal
  @override
  $ProviderElement<LibraryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LibraryRepository create(Ref ref) {
    return libraryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibraryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibraryRepository>(value),
    );
  }
}

String _$libraryRepositoryHash() => r'3702786bd8e95a10248d0525fc3d5da854c0190b';

@ProviderFor(favoritesRepository)
final favoritesRepositoryProvider = FavoritesRepositoryProvider._();

final class FavoritesRepositoryProvider
    extends
        $FunctionalProvider<
          FavoritesRepository,
          FavoritesRepository,
          FavoritesRepository
        >
    with $Provider<FavoritesRepository> {
  FavoritesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesRepositoryHash();

  @$internal
  @override
  $ProviderElement<FavoritesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FavoritesRepository create(Ref ref) {
    return favoritesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavoritesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavoritesRepository>(value),
    );
  }
}

String _$favoritesRepositoryHash() =>
    r'6a7576869475c859e7df4a8aa775de2e22dd0c39';

@ProviderFor(downloadsRepository)
final downloadsRepositoryProvider = DownloadsRepositoryProvider._();

final class DownloadsRepositoryProvider
    extends
        $FunctionalProvider<
          DownloadsRepository,
          DownloadsRepository,
          DownloadsRepository
        >
    with $Provider<DownloadsRepository> {
  DownloadsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadsRepositoryHash();

  @$internal
  @override
  $ProviderElement<DownloadsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DownloadsRepository create(Ref ref) {
    return downloadsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DownloadsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DownloadsRepository>(value),
    );
  }
}

String _$downloadsRepositoryHash() =>
    r'17b9e8b2a5625be951d380cbce4063623435f901';

@ProviderFor(downloadService)
final downloadServiceProvider = DownloadServiceProvider._();

final class DownloadServiceProvider
    extends
        $FunctionalProvider<DownloadService, DownloadService, DownloadService>
    with $Provider<DownloadService> {
  DownloadServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadServiceHash();

  @$internal
  @override
  $ProviderElement<DownloadService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DownloadService create(Ref ref) {
    return downloadService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DownloadService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DownloadService>(value),
    );
  }
}

String _$downloadServiceHash() => r'47b61ef14984190a30e350cd2ee83141d25e98d6';

@ProviderFor(recentlyPlayedRepository)
final recentlyPlayedRepositoryProvider = RecentlyPlayedRepositoryProvider._();

final class RecentlyPlayedRepositoryProvider
    extends
        $FunctionalProvider<
          RecentlyPlayedRepository,
          RecentlyPlayedRepository,
          RecentlyPlayedRepository
        >
    with $Provider<RecentlyPlayedRepository> {
  RecentlyPlayedRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentlyPlayedRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentlyPlayedRepositoryHash();

  @$internal
  @override
  $ProviderElement<RecentlyPlayedRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecentlyPlayedRepository create(Ref ref) {
    return recentlyPlayedRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecentlyPlayedRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecentlyPlayedRepository>(value),
    );
  }
}

String _$recentlyPlayedRepositoryHash() =>
    r'9514bcf1d35a2a7cd776dbe2a438bfb7998aa379';

@ProviderFor(androidAutoSessionService)
final androidAutoSessionServiceProvider = AndroidAutoSessionServiceProvider._();

final class AndroidAutoSessionServiceProvider
    extends
        $FunctionalProvider<
          AndroidAutoSessionService,
          AndroidAutoSessionService,
          AndroidAutoSessionService
        >
    with $Provider<AndroidAutoSessionService> {
  AndroidAutoSessionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'androidAutoSessionServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$androidAutoSessionServiceHash();

  @$internal
  @override
  $ProviderElement<AndroidAutoSessionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AndroidAutoSessionService create(Ref ref) {
    return androidAutoSessionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AndroidAutoSessionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AndroidAutoSessionService>(value),
    );
  }
}

String _$androidAutoSessionServiceHash() =>
    r'274f6b932c86c0128b1e3e1f217a20b418b64b3c';

@ProviderFor(localPlayerInstance)
final localPlayerInstanceProvider = LocalPlayerInstanceProvider._();

final class LocalPlayerInstanceProvider
    extends
        $FunctionalProvider<
          LocalPlayerService,
          LocalPlayerService,
          LocalPlayerService
        >
    with $Provider<LocalPlayerService> {
  LocalPlayerInstanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localPlayerInstanceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localPlayerInstanceHash();

  @$internal
  @override
  $ProviderElement<LocalPlayerService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalPlayerService create(Ref ref) {
    return localPlayerInstance(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalPlayerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalPlayerService>(value),
    );
  }
}

String _$localPlayerInstanceHash() =>
    r'2a3086e50b99b193385c1324c760bfa0ede176b9';

@ProviderFor(androidAutoPlayerInstance)
final androidAutoPlayerInstanceProvider = AndroidAutoPlayerInstanceProvider._();

final class AndroidAutoPlayerInstanceProvider
    extends
        $FunctionalProvider<
          AndroidAutoPlayerService,
          AndroidAutoPlayerService,
          AndroidAutoPlayerService
        >
    with $Provider<AndroidAutoPlayerService> {
  AndroidAutoPlayerInstanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'androidAutoPlayerInstanceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$androidAutoPlayerInstanceHash();

  @$internal
  @override
  $ProviderElement<AndroidAutoPlayerService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AndroidAutoPlayerService create(Ref ref) {
    return androidAutoPlayerInstance(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AndroidAutoPlayerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AndroidAutoPlayerService>(value),
    );
  }
}

String _$androidAutoPlayerInstanceHash() =>
    r'7b2334062626934b322d99e5a3191e312bb5773c';

@ProviderFor(jrrAudioHandler)
final jrrAudioHandlerProvider = JrrAudioHandlerProvider._();

final class JrrAudioHandlerProvider
    extends
        $FunctionalProvider<JrrAudioHandler, JrrAudioHandler, JrrAudioHandler>
    with $Provider<JrrAudioHandler> {
  JrrAudioHandlerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jrrAudioHandlerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jrrAudioHandlerHash();

  @$internal
  @override
  $ProviderElement<JrrAudioHandler> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JrrAudioHandler create(Ref ref) {
    return jrrAudioHandler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JrrAudioHandler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JrrAudioHandler>(value),
    );
  }
}

String _$jrrAudioHandlerHash() => r'56d60c0b6ccef704525b468886130b1d3219ed1d';

@ProviderFor(audioHandler)
final audioHandlerProvider = AudioHandlerProvider._();

final class AudioHandlerProvider
    extends $FunctionalProvider<AudioHandler, AudioHandler, AudioHandler>
    with $Provider<AudioHandler> {
  AudioHandlerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioHandlerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioHandlerHash();

  @$internal
  @override
  $ProviderElement<AudioHandler> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AudioHandler create(Ref ref) {
    return audioHandler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioHandler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioHandler>(value),
    );
  }
}

String _$audioHandlerHash() => r'e9f9065cac678275ff97e0dee21b15da6e6b123c';
