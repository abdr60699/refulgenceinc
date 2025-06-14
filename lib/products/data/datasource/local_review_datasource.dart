import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entity/review_entities.dart';

class LocalReviewDatasource {
  static const _reviewsKey = 'product_reviews';

  Future<List<Review>> getReviewsForProduct(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final reviewsJson = prefs.getStringList(_reviewsKey) ?? [];

    debugPrint('Loading reviews for product $productId');
    debugPrint('Stored reviews: $reviewsJson');

    final reviews = reviewsJson
        .map((json) {
          final map = jsonDecode(json) as Map<String, dynamic>;
          return Review(
            id: map['id'],
            name: map['name'],
            email: map['email'],
            body: map['body'],
            productId: map['productId'],
          );
        })
        .where((review) => review.productId == productId)
        .toList();

    debugPrint('Found ${reviews.length} reviews for product $productId');
    return reviews;
  }

  Future<void> addReview(Review review) async {
    final prefs = await SharedPreferences.getInstance();
    final existingReviews = prefs.getStringList(_reviewsKey) ?? [];


    final newReview = Review(
      id: DateTime.now().millisecondsSinceEpoch,
      name: review.name,
      email: review.email,
      body: review.body,
      productId: review.productId,
    );


    final newReviewJson = jsonEncode({
      'id': newReview.id,
      'name': newReview.name,
      'email': newReview.email,
      'body': newReview.body,
      'productId': newReview.productId,
    });

    await prefs.setStringList(_reviewsKey, [...existingReviews, newReviewJson]);

    debugPrint('Saved review: $newReviewJson');
  }
}
