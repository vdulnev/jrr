import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/navigation_notifier.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../connection/providers/session_provider.dart';
import '../../queue/providers/queue_provider.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../../zones/providers/zone_provider.dart';
import '../providers/player_provider.dart';
import '../providers/polling_provider.dart';
import 'artwork_widget.dart';
import 'seek_bar.dart';
import 'transport_controls.dart';
import 'volume_control.dart';

@RoutePage()
class NowPlayingScreen extends ConsumerWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Start polling (keepAlive, so this only creates it once).
    ref.watch(pollingProvider);
    // Trigger zone list load and auto-selection.
    ref.watch(zoneListProvider);
    // Keep queue provider alive while on this screen so change counter is watched.
    ref.watch(queueProvider);

    final activeZone = ref.watch(activeZoneProvider);
    if (activeZone == null) {
      return const Scaffold(body: LoadingView());
    }

    final playerState = ref.watch(playerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(activeZone.name),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Menu',
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'JRiver Remote',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              ExpansionTile(
                leading: const Icon(Icons.library_music_outlined),
                title: const Text('Library'),
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 72),
                    title: const Text('Artists'),
                    onTap: () {
                      Navigator.pop(context);
                      ref
                          .read(navigationProvider.notifier)
                          .push(const LibraryRoute());
                    },
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 72),
                    title: const Text('Random Albums'),
                    onTap: () {
                      Navigator.pop(context);
                      ref
                          .read(navigationProvider.notifier)
                          .push(const RandomAlbumsRoute());
                    },
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.queue_music_outlined),
                title: const Text('Queue'),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(navigationProvider.notifier)
                      .push(const QueueRoute());
                },
              ),
              ListTile(
                leading: const Icon(Icons.speaker_group_outlined),
                title: const Text('Zones'),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(navigationProvider.notifier)
                      .push(const ZoneListRoute());
                },
              ),
              const Spacer(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Disconnect'),
                onTap: () => ref.read(sessionProvider.notifier).logout(),
              ),
            ],
          ),
        ),
      ),
      body: playerState.when(
        loading: () => const LoadingView(),
        error: (e, _) =>
            ErrorView(error: e, onRetry: () => ref.invalidate(playerProvider)),
        data: (status) => SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  ArtworkWidget(
                    imageUrl: status.trackInfo?.imageUrl,
                    size: 280,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Text(
                          status.trackInfo?.name ?? 'Nothing playing',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (status.trackInfo != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            status.trackInfo?.artist ?? '',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            status.trackInfo?.album ?? '',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SeekBar(
                    positionMs: status.positionMs,
                    durationMs: status.durationMs,
                    positionDisplay: status.positionDisplay,
                  ),
                  const SizedBox(height: 8),
                  TransportControls(status: status),
                  const SizedBox(height: 8),
                  VolumeControl(status: status),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      status.playingNowPositionDisplay.isNotEmpty
                          ? status.playingNowPositionDisplay
                          : '',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
