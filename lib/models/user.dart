// lib/models/user.dart

class UserModel {
  String fullName;
  String email;
  String password;
  String nim;
  String prodi;
  String? photoPath;

  UserModel({
    required this.fullName,
    required this.email,
    required this.password,
    this.nim = '',
    this.prodi = '',
    this.photoPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'nim': nim,
      'prodi': prodi,
      'photoPath': photoPath,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      nim: json['nim'] ?? '',
      prodi: json['prodi'] ?? '',
      photoPath: json['photoPath'],
    );
  }
}
