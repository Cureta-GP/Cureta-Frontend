class UserModel {
  final int id;
  final String username;
  final String email;
  final String phone;
  final String token;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'phone': phone,
    'token': token,
  };
}
