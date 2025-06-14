import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/product_entities.dart';
import '../provider/favourite_provider.dart';
import '../provider/user_provider.dart';
import '../screens/products_detail_screen.dart';
import 'offline_aware_image.dart';

class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

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
      margin: const EdgeInsets.symmetric(vertical: 5),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: OfflineAwareImage(
              imageUrl: 'https://picsum.photos/seed/${product.id}/600/300',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              product.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              product.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          userAsync.when(
            data: (user) => Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sold by ${user.name}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                toggleNotifier.isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: Icon(
                          (displayedFavoriteState == true)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: (displayedFavoriteState == true)
                              ? Colors.red
                              : Colors.grey,
                        ),
                        iconSize: 20,
                        onPressed: () async {
                          ref
                              .read(optimisticFavoriteProvider(product.id)
                                  .notifier)
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
                                  content:
                                      Text('Failed to update favorite: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
              ],
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text(
              'Error loading seller',
              style: TextStyle(color: Colors.red[400], fontSize: 12),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailsScreen(productId: product.id),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'View Product',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
