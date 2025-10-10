class AuthResponseModel {
  final bool success;
  final int statusCode;
  final String? message;
  final AuthDataModel? data;
  final dynamic errors;

  AuthResponseModel({
    required this.success,
    required this.statusCode,
    this.message,
    this.data,
    this.errors,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] ?? false,
      statusCode: int.tryParse(json['statusCode'].toString()) ?? 0,
      message: json['message'],
      data: json['data'] != null ? AuthDataModel.fromJson(json['data']) : null,
      errors: json['errors'],
    );
  }
}

class AuthDataModel {
  final String? id;
  final String? accessToken;
  final DateTime? expiresIn;
  final bool? isAuthenticated;
  final String? refreshToken;
  final DateTime? refreshTokenExpiration;
  final List<String>? roles;
  final String? firstName;
  final String? lastName;
  final String? userName;
  final String? email;
  final String? phoneNumber;

  AuthDataModel({
    this.id,
    this.accessToken,
    this.expiresIn,
    this.isAuthenticated,
    this.refreshToken,
    this.refreshTokenExpiration,
    this.roles,
    this.firstName,
    this.lastName,
    this.userName,
    this.email,
    this.phoneNumber,
  });

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    return AuthDataModel(
      id: json['id'] as String?,
      accessToken: json['accessToken'] as String?,
      expiresIn:
          json['expiresIn'] != null
              ? DateTime.tryParse(json['expiresIn'].toString())
              : null,
      isAuthenticated: json['isAuthinticated'] as bool?,
      refreshToken: json['refreshToken'] as String?,
      refreshTokenExpiration:
          json['refreshTokenExpiration'] != null
              ? DateTime.tryParse(json['refreshTokenExpiration'].toString())
              : null,
      roles:
          json['roles'] != null
              ? List<String>.from(json['roles'] as List<dynamic>)
              : null,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }
}
