import 'package:flutter/foundation.dart';

@immutable
class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.avatarUrl,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
