import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/navigation_notifier.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../providers/library_providers.dart';

@RoutePage()
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final artistsState = ref.watch(artistsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artists'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => ref.read(navigationProvider.notifier).pop(),
        ),
      ),
      body: artistsState.when(
        loading: () => const LoadingView(),
        error: (e, _) =>
            ErrorView(error: e, onRetry: () => ref.invalidate(artistsProvider)),
        data: (artists) {
          if (artists.isEmpty) {
            return const Center(child: Text('No artists found'));
          }
          final filtered = _filter.isEmpty
              ? artists
              : artists
                    .where(
                      (a) => a.toLowerCase().contains(_filter.toLowerCase()),
                    )
                    .toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Filter artists',
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _filter = v),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('No matches'))
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final artist = filtered[i];
                          return ListTile(
                            leading: const Icon(Icons.person_outline),
                            title: Text(artist),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => ref
                                .read(navigationProvider.notifier)
                                .push(ArtistAlbumsRoute(artist: artist)),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
