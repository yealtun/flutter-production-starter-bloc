import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/feed_cubit.dart';
import '../cubit/feed_state.dart';
import 'item_detail_screen.dart';

/// Feed screen with pagination and pull-to-refresh
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<FeedCubit>().loadItems();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<FeedCubit>().loadMore();
    }
  }

  Widget _buildStateWidget(FeedState state) {
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      success: (items, paginationMeta) => RefreshIndicator(
        onRefresh: () => context.read<FeedCubit>().loadItems(refresh: true),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: items.length + (paginationMeta.hasNextPage ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == items.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final item = items[index];
            return ListTile(
              title: Text(item.title),
              subtitle: Text(
                item.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<ItemDetailScreen>(
                    builder: (_) => ItemDetailScreen(item: item),
                  ),
                );
              },
            );
          },
        ),
      ),
      empty: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No items found'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  context.read<FeedCubit>().loadItems(refresh: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      error: (error) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: ${error.message}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  context.read<FeedCubit>().loadItems(refresh: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: BlocBuilder<FeedCubit, FeedState>(
        builder: (context, state) => _buildStateWidget(state),
      ),
    );
  }
}
