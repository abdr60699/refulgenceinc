import 'package:dio/dio.dart';

import '../model/product_model.dart';
import '../model/review_model.dart';
import '../model/user_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<UserModel> getUser(int userId);
  Future<List<ReviewModel>> getReviewsForProduct(int productId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/posts');

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

    @override
  Future<UserModel> getUser(int userId) async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/users/$userId');
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load user');
    }
  }

   @override
  Future<List<ReviewModel>> getReviewsForProduct(int productId) async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/comments?postId=$productId');
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => ReviewModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

}
