class UserModel {
  final String id;
  final String email;
  final String role;
  final String token;
  final String? name;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.token,
    this.name,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? fallbackToken}) {
    return UserModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? 'client').toString(),
      token: (json['accessToken'] ?? fallbackToken ?? '').toString(),
      name: json['name'] as String?,
      avatarUrl: json['avatarUrl'] ?? json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'accessToken': token,
      'name': name,
      'avatarUrl': avatarUrl,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? role,
    String? token,
    String? name,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      token: token ?? this.token,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}