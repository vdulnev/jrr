// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// List of favorited browse items

@ProviderFor(Favorites)
final favoritesProvider = FavoritesProvider._();

/// List of favorited browse items
final class FavoritesProvider
    extends $AsyncNotifierProvider<Favorites, List<BrowseItem>> {
  /// List of favorited browse items
  FavoritesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesHash();

  @$internal
  @override
  Favorites create() => Favorites();
}

String _$favoritesHash() => r'e363e7019ff5ccaa90b3d072cb0323fc8b9edd1f';

/// List of favorited browse items

abstract class _$Favorites extends $AsyncNotifier<List<BrowseItem>> {
  FutureOr<List<BrowseItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<BrowseItem>>, List<BrowseItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<BrowseItem>>, List<BrowseItem>>,
              AsyncValue<List<BrowseItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
