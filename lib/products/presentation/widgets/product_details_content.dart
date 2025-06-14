import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/product_entities.dart';
import '../../domain/entity/user_entities.dart';
import '../provider/user_provider.dart';
import 'offline_aware_image.dart';

class ProductDetailsContent extends ConsumerWidget {
  final Product product;
  final WidgetRef ref;

  const ProductDetailsContent({
    super.key,
    required this.product,
    required this.ref,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 24),
            Text(
              product.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Consumer(
              builder: (context, ref, child) {
                final userAsync = ref.watch(userProvider(product.userId));
                return userAsync.when(
                  data: (user) => _buildSellerInfo(user),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => const Text('Somethine Went Wrong'),
                );
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Customer Reviews',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSellerInfo(User user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue[100],
            child: Text(
              user.name[0].toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sold by',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
