class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String university;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.university,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String userEmail) {
    return UserModel(
      id: map['id'] as String? ?? '',
      email: userEmail,
      fullName: map['full_name'] as String? ?? '',
      university: map['university'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'university': university,
    };
  }
}
