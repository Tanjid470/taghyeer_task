import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.image,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int,
        username: json['username'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        email: json['email'] as String,
        image: json['image'] as String? ?? '',
        token: json['accessToken'] as String? ?? json['token'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'image': image,
        'token': token,
      };
}
