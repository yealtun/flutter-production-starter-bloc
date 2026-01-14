import 'package:flutter/material.dart';
import '../../domain/entities/item.dart';

/// Item detail screen
class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
            if (item.userId != null) ...[
              const SizedBox(height: 8),
              Text(
                'User ID: ${item.userId}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ],
            const SizedBox(height: 16),
            Text(item.body, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
