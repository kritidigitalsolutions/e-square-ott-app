class EditProfilePayload {
  final String firstName;
  final String lastName;
  final String email;
  final String avatarUrl;

  EditProfilePayload({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }
}
