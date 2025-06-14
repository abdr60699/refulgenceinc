

import '../../domain/entity/review_entities.dart';

class ReviewModel extends Review {
  ReviewModel({
    required int id,
    required String name,
    required String email,
    required String body,
    required int productId,
  }) : super(
          id: id,
          name: name,
          email: email,
          body: body,
          productId: productId,
        );

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      body: json['body'],
      productId: json['postId'], 
    );
  }
}