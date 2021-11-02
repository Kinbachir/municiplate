import 'package:flutter/foundation.dart';

@immutable
class User {
  const User({
    required this.name,
    required this.email,
    required this.role,
    required this.tel,
  });

  User.fromJson(Map<String, Object?> json)
      : this(
          name: json['name'] as String,
          email: json['email'] as String,
          role: json['role']! as String,
          tel: json['tel']! as String,
        );

  final String role;
  final String email;
  final String tel;
  final String name;

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'tel': tel,
    };
  }
}
