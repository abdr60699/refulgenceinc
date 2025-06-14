import 'package:ecommerce/products/presentation/provider/product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/user_entities.dart';

final userProvider = FutureProvider.family<User, int>((ref, userId) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getUser(userId);
});
