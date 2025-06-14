import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/favourite_local_datasource.dart';
import '../../domain/entity/product_entities.dart';
import 'product_provider.dart';

final favoriteLocalDatasourceProvider =
    Provider<FavoriteLocalDatasource>((ref) {
  return FavoriteLocalDatasource();
});

final favoriteProductsProvider = FutureProvider<List<Product>>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getFavoriteProducts();
});

final toggleFavoriteProvider =
    FutureProvider.family<void, Product>((ref, product) async {
  final repository = ref.watch(productRepositoryProvider);
  final isFav = await repository.isFavorite(product.id);

  if (isFav) {
    await repository.removeFavorite(product.id);
  } else {
    await repository.addFavorite(product);
  }
  ref.invalidate(isFavoriteProvider(product.id));
  ref.invalidate(favoriteProductsProvider);
});

final isFavoriteProvider =
    FutureProvider.family<bool, int>((ref, productId) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.isFavorite(productId);
});
