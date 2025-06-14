import '../../domain/entity/product_entities.dart';
import '../../domain/entity/review_entities.dart';
import '../../domain/entity/user_entities.dart';
import '../../domain/repository/product_repository.dart';
import '../datasource/favourite_local_datasource.dart';
import '../datasource/local_review_datasource.dart';
import '../datasource/remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final LocalReviewDatasource localReviewDatasource;
  final FavoriteLocalDatasource localFavoriteLocalDatasource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localReviewDatasource,
    required this.localFavoriteLocalDatasource,
  });

  @override
  Future<List<Product>> getProducts() async {
    return await remoteDataSource.getProducts();
  }

  @override
  Future<User> getUser(int userId) async {
    return await remoteDataSource.getUser(userId);
  }


  @override
  Future<List<Review>> getReviewsForProduct(int productId) async {
    try {
      final apiReviews = await remoteDataSource.getReviewsForProduct(productId);
      final localReviews =
          await localReviewDatasource.getReviewsForProduct(productId);


      return [...apiReviews, ...localReviews]
        ..sort((a, b) => b.id.compareTo(a.id));
    } catch (e) {

      final localReviews =
          await localReviewDatasource.getReviewsForProduct(productId);
      return localReviews..sort((a, b) => b.id.compareTo(a.id));
    }
  }


  @override
  Future<Review> addReview(Review review) async {

    final reviewToAdd = Review(
      id: DateTime.now().millisecondsSinceEpoch,
      name: review.name,
      email: review.email,
      body: review.body,
      productId: review.productId,
    );

    await localReviewDatasource.addReview(reviewToAdd);
    return reviewToAdd;
  }

  @override
  Future<List<Product>> getFavoriteProducts() async {
    return await localFavoriteLocalDatasource.getFavorites();
  }

  @override
  Future<void> addFavorite(Product product) async {
    await localFavoriteLocalDatasource.addFavorite(product);
  }

  @override
  Future<void> removeFavorite(int productId) async {
    await localFavoriteLocalDatasource.removeFavorite(productId);
  }

  @override
  Future<bool> isFavorite(int productId) async {
    return await localFavoriteLocalDatasource.isFavorite(productId);
  }
}
