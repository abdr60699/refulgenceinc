import '../entity/product_entities.dart';
import '../entity/review_entities.dart';
import '../entity/user_entities.dart';


abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<User> getUser(int userId);
  Future<List<Review>> getReviewsForProduct(int productId);
  Future<Review> addReview(Review review);
  Future<List<Product>> getFavoriteProducts();
  Future<void> addFavorite(Product product);
  Future<void> removeFavorite(int productId);
  Future<bool> isFavorite(int productId); 
}