import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/navigation_notifier.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/sub_screen_header.dart';
import '../data/models/album.dart';
import 'album_row_tile.dart';

class AlbumListScreen extends ConsumerStatefulWidget {
  final List<Album> albums;
  final String title;
  final String? subtitle;
  final VoidCallback? onRefresh;
  final VoidCallback? onBack;
  final bool showArtist;

  const AlbumListScreen({
    required this.albums,
    required this.title,
    this.subtitle,
    this.onRefresh,
    this.onBack,
    this.showArtist = true,
    super.key,
  });

  @override
  ConsumerState<AlbumListScreen> createState() => _AlbumListScreenState();
}

class _AlbumListScreenState extends ConsumerState<AlbumListScreen> {
  String _filter = '';

  List<Album> _filtered(List<Album> albums) {
    if (_filter.isEmpty) return albums;
    final lower = _filter.toLowerCase();
    return albums.where((a) => a.name.toLowerCase().contains(lower)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final albums = widget.albums;
    final filtered = _filtered(albums);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SubScreenHeader(
              title: widget.title,
              subtitle: widget.subtitle,
              onBack: widget.onBack ??
                  () => ref.read(navigationProvider.notifier).pop(),
              trailing: widget.onRefresh != null
                  ? GestureDetector(
                      onTap: widget.onRefresh,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.line2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Refresh',
                          style: AppTextStyles.accentSmall,
                        ),
                      ),
                    )
                  : null,
            ),
            // Filter field
            if (albums.length > 5)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Filter albums\u2026',
                    prefixIcon: Icon(Icons.search, size: 18),
                    isDense: true,
                  ),
                  style: AppTextStyles.labelLarge,
                  onChanged: (v) => setState(() => _filter = v),
                ),
              ),
            // Album list
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text(
                        'No matches',
                        style: AppTextStyles.emptyState,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 148),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => AlbumRowTile(
                        album: filtered[i],
                        showArtist: widget.showArtist,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
