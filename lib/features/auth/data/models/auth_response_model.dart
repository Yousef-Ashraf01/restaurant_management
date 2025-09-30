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
  final int? expiresIn;
  final bool? isAuthinticated;
  final String? refreshToken;
  final String? refreshTokenExpiration;
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
    this.isAuthinticated,
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
      expiresIn: json['expiresIn'] is int
          ? json['expiresIn']
          : int.tryParse(json['expiresIn'].toString()),
      isAuthinticated: json['isAuthinticated'] as bool?,
      refreshToken: json['refreshToken'] as String?,
      refreshTokenExpiration: json['refreshTokenExpiration'] as String?,
      roles: json['roles'] != null
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
