class UserModel {
  final int id;
  final String username;
  final String email;
  final String fullName;
  final String? phone;
  final String? token;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.phone,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      fullName: json['full_name'],
      phone: json['phone'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'token': token,
    };
  }
}
