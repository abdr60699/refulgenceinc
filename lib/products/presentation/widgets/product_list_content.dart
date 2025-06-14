import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/paginated_products_provider.dart';
import '../provider/sort_filter_provider.dart';
import 'product_list_loading.dart';
import 'product_list_error.dart';
import 'product_list_items.dart';

class ProductListContent extends ConsumerWidget {
  final ScrollController scrollController;

  const ProductListContent({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(paginatedProductsProvider);
    final filter = ref.watch(filterProvider);
    final sort = ref.watch(sortProvider);

    return productsAsync.when(
      data: (products) {
        var filteredProducts = products.where((product) {
          return product.title.toLowerCase().contains(filter.toLowerCase()) ||
              product.description.toLowerCase().contains(filter.toLowerCase());
        }).toList();

        if (sort == 'name') {
          filteredProducts.sort((a, b) => a.title.compareTo(b.title));
        } else if (sort == 'seller') {
          filteredProducts.sort((a, b) => a.userId.compareTo(b.userId));
        }

        return ProductListItems(
          products: filteredProducts,
          scrollController: scrollController,
          isLoading: productsAsync.isLoading,
        );
      },
      loading: () => const ProductListLoading(),
      error: (e, _) => ProductListError(error: e),
    );
  }
}