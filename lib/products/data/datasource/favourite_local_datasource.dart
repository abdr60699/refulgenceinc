import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../domain/entity/product_entities.dart';

class FavoriteLocalDatasource {
  static const _favoritesKey = 'favorite_products';

  Future<List<Product>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];

    return favoritesJson.map((json) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return Product(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        userId: map['userId'],
      );
    }).toList();
  }

  Future<void> addFavorite(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final existingFavorites = prefs.getStringList(_favoritesKey) ?? [];

    final newFavoriteJson = jsonEncode({
      'id': product.id,
      'title': product.title,
      'description': product.description,
      'userId': product.userId,
    });

    await prefs
        .setStringList(_favoritesKey, [...existingFavorites, newFavoriteJson]);
  }

  Future<void> removeFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];

    final updatedFavorites = favoritesJson.where((json) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return map['id'] != productId;
    }).toList();

    await prefs.setStringList(_favoritesKey, updatedFavorites);
  }

  Future<bool> isFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];

    return favoritesJson.any((json) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return map['id'] == productId;
    });
  }
}
