class LoginResponseModel {
  final String id;
  final String accessToken;
  final String refreshToken;
  final List<String> roles;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String phoneNumber;

  LoginResponseModel({
    required this.id,
    required this.accessToken,
    required this.refreshToken,
    required this.roles,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      id: json['id'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      roles: List<String>.from(json['roles']),
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
