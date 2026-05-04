import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jrr_f/features/library/data/models/album.dart';

import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/sub_screen_header.dart';
import '../providers/library_providers.dart';
import 'album_list_screen.dart';

@RoutePage()
class ArtistAlbumsScreen extends ConsumerWidget {
  final String artist;

  const ArtistAlbumsScreen({required this.artist, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(albumsByArtistProvider(artist));
    return state.when(
      loading: () => Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SubScreenHeader(
                title: artist,
                subtitle: 'Artist',
                onBack: () => context.router.maybePop(),
              ),
              const Expanded(child: LoadingView()),
            ],
          ),
        ),
      ),
      error: (e, _) => Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SubScreenHeader(
                title: artist,
                subtitle: 'Artist',
                onBack: () => context.router.maybePop(),
              ),
              Expanded(
                child: ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(albumsByArtistProvider(artist)),
                ),
              ),
            ],
          ),
        ),
      ),
      data: (albums) {
        final sortedAlbums = [...albums]
          ..sort((a, b) => a.name.compareTo(b.name));

        final discGroups = <String, List<Album>>{};
        final otherAlbums = <Album>[];

        for (final album in sortedAlbums) {
          if (album.totalDiscs > 1 &&
              album.discNumber > 0 &&
              album.parentFolderPath.isNotEmpty) {
            final key = '${album.name}|${album.parentFolderPath}';
            discGroups.putIfAbsent(key, () => []).add(album);
          } else {
            otherAlbums.add(album);
          }
        }

        final groups = <AlbumGroup>[];

        // Process multi-disc groups
        for (final entry in discGroups.entries) {
          final discs = entry.value
            ..sort((a, b) => a.discNumber.compareTo(b.discNumber));

          if (discs.length > 1) {
            final first = discs.first;
            final latestDate = discs
                .map((d) => d.date)
                .where((d) => d.isNotEmpty)
                .toList()
              ..sort();
            final parent = first.copyWith(
              folderPath: first.parentFolderPath,
              discNumber: 0,
              date: latestDate.isNotEmpty ? latestDate.last : first.date,
            );
            groups.add(AlbumGroup(album: parent, discs: discs));
          } else {
            // Only one disc found for this name/parent folder, treat as single
            groups.add(AlbumGroup(album: discs.first));
          }
        }

        // Process single albums
        for (final album in otherAlbums) {
          groups.add(AlbumGroup(album: album));
        }

        // Final sort of groups: by date then by name
        groups.sort((a, b) {
          final dateCompare = a.date.compareTo(b.date);
          if (dateCompare != 0) return dateCompare;
          return a.album.name.compareTo(b.album.name);
        });

        return AlbumListScreen(
          groups: groups,
          title: artist,
          subtitle: 'Artist',
          showArtist: false,
          onBack: () => context.router.maybePop(),
          onRefresh: () => ref.invalidate(albumsByArtistProvider(artist)),
        );
      },
    );
  }
}
