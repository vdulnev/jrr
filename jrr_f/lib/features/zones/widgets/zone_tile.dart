import 'package:flutter/material.dart';

import '../data/models/zone.dart';

class ZoneTile extends StatelessWidget {
  final Zone zone;
  final bool isSelected;
  final VoidCallback onTap;

  const ZoneTile({
    super.key,
    required this.zone,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        zone.isDLNA ? Icons.cast : Icons.speaker,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      title: Text(zone.name),
      subtitle: zone.isDLNA ? const Text('DLNA') : null,
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      selected: isSelected,
      onTap: onTap,
    );
  }
}
