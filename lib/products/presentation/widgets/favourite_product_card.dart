import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/product_entities.dart';
import '../provider/favourite_provider.dart';
import '../provider/user_provider.dart';
import 'offline_aware_image.dart';

class FavouriteProductCard extends ConsumerWidget {
  final Product product;

  const FavouriteProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(product.userId));
    final isFavoriteAsync = ref.watch(isFavoriteProvider(product.id));
    final optimisticFavorite =
        ref.watch(optimisticFavoriteProvider(product.id));
    final toggleNotifier = ref.watch(favoriteToggleNotifierProvider);

    final displayedFavoriteState = optimisticFavorite ??
        isFavoriteAsync.maybeWhen(data: (data) => data, orElse: () => false);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: OfflineAwareImage(
              imageUrl: 'https://picsum.photos/seed/${product.id}/600/300',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: Container(
                color: Colors.grey[200],
                child: const Center(
                    child: Icon(Icons.favorite, color: Colors.red)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: userAsync.when(
                  data: (user) => Text(
                    'Sold by ${user.name}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text('Error loading seller'),
                ),
              ),
              toggleNotifier.isLoading
                  ? const CircularProgressIndicator()
                  : IconButton(
                      icon: Icon(
                        (displayedFavoriteState == true)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: (displayedFavoriteState == true)
                            ? Colors.red
                            : null,
                      ),
                      onPressed: () async {
                        ref
                            .read(
                                optimisticFavoriteProvider(product.id).notifier)
                            .toggleOptimistic();

                        try {
                          await ref
                              .read(favoriteToggleNotifierProvider.notifier)
                              .toggleFavorite(product);

                          ref
                              .read(optimisticFavoriteProvider(product.id)
                                  .notifier)
                              .resetToActual();
                        } catch (e) {
                          ref
                              .read(optimisticFavoriteProvider(product.id)
                                  .notifier)
                              .toggleOptimistic();

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to update favorite: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
