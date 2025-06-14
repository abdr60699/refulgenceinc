import '../../domain/entity/user_entities.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.username,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
    );
  }
}