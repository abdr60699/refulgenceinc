import 'package:ecommerce/products/domain/entity/product_entities.dart';
import 'package:ecommerce/products/presentation/provider/product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paginatedProductsProvider =
    StateNotifierProvider<PaginatedProductsNotifier, AsyncValue<List<Product>>>(
        (ref) {
  return PaginatedProductsNotifier(ref);
});

class PaginatedProductsNotifier
    extends StateNotifier<AsyncValue<List<Product>>> {
  final Ref ref;
  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;

  PaginatedProductsNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadMore();
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;

    try {
      final newProducts = await ref.read(getProductsUseCaseProvider).call();
      final currentProducts = state.valueOrNull ?? [];

      final startIndex = (_page - 1) * _limit;
      final endIndex = startIndex + _limit;
      final paginatedProducts = newProducts.sublist(
        0,
        endIndex.clamp(0, newProducts.length),
      );

      _hasMore = endIndex < newProducts.length;
      _page++;

      state = AsyncValue.data([...currentProducts, ...paginatedProducts]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    state = const AsyncValue.loading();
    await loadMore();
  }
}
