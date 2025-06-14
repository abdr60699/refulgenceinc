import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/favourite_local_datasource.dart';
import '../../data/datasource/local_review_datasource.dart';
import '../../data/datasource/remote_datasource.dart';
import '../../data/repository/product_repository_impl.dart';
import '../../domain/entity/product_entities.dart';
import '../../domain/usecase/get_products.dart';

final productListProvider = FutureProvider<List<Product>>((ref) async {
  final useCase = ref.watch(getProductsUseCaseProvider);
  return await useCase();
});

final getProductsUseCaseProvider = Provider<GetProducts>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProducts(repository);
});


final productRepositoryProvider = Provider<ProductRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(remoteDataSourceProvider);
  final localReviewDatasource = LocalReviewDatasource(); 
  final localFavoriteLocalDatasource =
      FavoriteLocalDatasource(); 
  return ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localReviewDatasource: localReviewDatasource,
      localFavoriteLocalDatasource:
          localFavoriteLocalDatasource 
      );
});

final remoteDataSourceProvider = Provider<ProductRemoteDataSourceImpl>((ref) {
  final dio = Dio(); 
  return ProductRemoteDataSourceImpl(dio: dio);
});



