import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/sub_screen_header.dart';
import '../data/models/album_group.dart';
import 'album_row_tile.dart';

class AlbumListScreen extends ConsumerStatefulWidget {
  final List<AlbumGroup> groups;
  final String title;
  final String? subtitle;
  final VoidCallback? onRefresh;
  final VoidCallback? onBack;
  final bool showArtist;

  const AlbumListScreen({
    required this.groups,
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
  final Set<String> _expandedGroups = {};

  List<AlbumGroup> _filtered(List<AlbumGroup> groups) {
    if (_filter.isEmpty) return groups;
    final lower = _filter.toLowerCase();
    return groups
        .where((g) => g.album.name.toLowerCase().contains(lower))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final groups = widget.groups;
    final filtered = _filtered(groups);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SubScreenHeader(
              title: widget.title,
              subtitle: widget.subtitle,
              onBack: widget.onBack ?? () => context.router.maybePop(),
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
            if (groups.length > 5)
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
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final group = filtered[i];
                        final isExpanded = _expandedGroups.contains(group.id);
                        final hasSubItems = group.isMultiDisc;

                        return Column(
                          children: [
                            AlbumRowTile(
                              album: group.album,
                              showArtist: widget.showArtist,
                              hasSubItems: hasSubItems,
                              isExpanded: isExpanded,
                              onToggle: () => setState(() {
                                if (isExpanded) {
                                  _expandedGroups.remove(group.id);
                                } else {
                                  _expandedGroups.add(group.id);
                                }
                              }),
                            ),
                            if (isExpanded)
                              ...group.discs.map(
                                (disc) => AlbumRowTile(
                                  album: disc,
                                  showArtist: widget.showArtist,
                                  indent: 44,
                                  titleOverride:
                                      'Disc ${disc.discNumber}/${disc.totalDiscs}',
                                ),
                              ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
