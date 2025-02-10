// models/user_model.dart

class UserModel {
  final String phoneNumber;
  final String? firstName;
  final String? lastName;
  final bool otpVerified;

  UserModel({
    required this.phoneNumber,
    this.firstName,
    this.lastName,
    required this.otpVerified,
  });

  // Factory method to convert JSON to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phoneNumber: json['phoneNumber'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      otpVerified: json['otpVerified'] ?? false,
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
