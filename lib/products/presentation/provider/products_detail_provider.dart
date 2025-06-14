import 'package:ecommerce/products/domain/entity/product_entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/review_entities.dart';
import 'product_provider.dart';

final productDetailsProvider =
    FutureProvider.family<Product, int>((ref, productId) async {
  final repository = ref.read(productRepositoryProvider);
  final products = await repository.getProducts();
  return products.firstWhere((product) => product.id == productId);
});

final productReviewsProvider =
    FutureProvider.family<List<Review>, int>((ref, productId) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getReviewsForProduct(productId);
});

final addReviewProvider =
    FutureProvider.family<Review, Review>((ref, review) async {
  final repository = ref.read(productRepositoryProvider);
  await repository.addReview(review);
  ref.invalidate(productReviewsProvider(review.productId));
  return review;
});