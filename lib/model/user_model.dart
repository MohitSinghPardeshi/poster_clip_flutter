class UserModel {
  final String name;
  final String designation;
  final String profileImagePath;

  UserModel({
    required this.name,
    required this.designation,
    required this.profileImagePath,
  });

  // Add a copyWith method for updating specific fields
  UserModel copyWith({
    String? name,
    String? designation,
    String? profileImagePath,
  }) {
    return UserModel(
      name: name ?? this.name,
      designation: designation ?? this.designation,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}
