class RegisterRequestModel {
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String phoneNumber;
  final String userName;

  RegisterRequestModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.phoneNumber,
    required this.userName,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "password": password,
      "phoneNumber": phoneNumber,
      "userName": userName,
    };
  }
}
