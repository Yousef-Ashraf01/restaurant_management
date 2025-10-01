// lib/features/auth/data/models/change_password_request_model.dart

class ChangePasswordRequestModel {
  final String userId;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordRequestModel({
    required this.userId,
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "currentPassword": currentPassword,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };
  }
}
