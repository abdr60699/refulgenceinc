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

final favoriteToggleNotifierProvider = 
    AsyncNotifierProvider<FavoriteToggleNotifier, void>(
  FavoriteToggleNotifier.new,
);

class FavoriteToggleNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
  }

  Future<void> toggleFavorite(Product product) async {
    state = const AsyncLoading();
    
    try {
      final repository = ref.read(productRepositoryProvider);
      final isFav = await repository.isFavorite(product.id);

      if (isFav) {
        await repository.removeFavorite(product.id);
      } else {
        await repository.addFavorite(product);
      }

      ref.invalidate(isFavoriteProvider(product.id));
      ref.invalidate(favoriteProductsProvider);
      
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final isFavoriteProvider =
    FutureProvider.family<bool, int>((ref, productId) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.isFavorite(productId);
});

final optimisticFavoriteProvider = 
    StateNotifierProvider.family<OptimisticFavoriteNotifier, bool?, int>(
  (ref, productId) => OptimisticFavoriteNotifier(ref, productId),
);

class OptimisticFavoriteNotifier extends StateNotifier<bool?> {
  final Ref ref;
  final int productId;

  OptimisticFavoriteNotifier(this.ref, this.productId) : super(null) {
    _initializeState();
  }

  void _initializeState() async {
    final actualState = await ref.read(isFavoriteProvider(productId).future);
    if (mounted) {
      state = actualState;
    }
  }

  void toggleOptimistic() {
    state = !(state ?? false);
  }

  void resetToActual() async {
    try {
      final actualState = await ref.read(isFavoriteProvider(productId).future);
      if (mounted) {
        state = actualState;
      }
    } catch (e) {
      
    }
  }
}