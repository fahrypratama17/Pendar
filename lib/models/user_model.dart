class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String university;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.university,
    this.avatarUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String userEmail) {
    return UserModel(
      id: map['id'] as String? ?? '',
      email: userEmail,
      fullName: map['full_name'] as String? ?? '',
      university: map['university'] as String? ?? '',
      avatarUrl: map['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'university': university,
      'avatar_url': avatarUrl,
    };
  }
}
