import 'package:flutter/material.dart';

import '../../domain/entity/product_entities.dart';
import 'product_card.dart';

class ProductListItems extends StatelessWidget {
  final List<Product> products;
  final ScrollController scrollController;
  final bool isLoading;

  const ProductListItems({
    super.key,
    required this.products,
    required this.scrollController,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= products.length) return null;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ProductCard(product: products[index]),
                );
              },
              childCount: products.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: isLoading
                  ? Column(
                      children: [
                        const CircularProgressIndicator(strokeWidth: 3),
                        const SizedBox(height: 16),
                        Text(
                          'Loading more products...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'You\'ve seen all products!',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}