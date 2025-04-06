// This class represents a single user and their details
class UserModel {
  // Basic user properties
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  // Job is optional because not every user might have a job assigned
  String? job;

  // Constructor to initialize the user object
  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    this.job, // Job is optional so it's not marked as required
  });

  // Factory method to create a UserModel instance from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
      // Note: 'job' isn't fetched from JSON here—can be set later if needed
    );
  }
}