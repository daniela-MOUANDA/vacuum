class Profile {
  final int id;
  final int userId;
  final String skills;
  final String province;
  final String city;
  final String? bio;
  final String? profilePicture;

  Profile({
    required this.id,
    required this.userId,
    required this.skills,
    required this.province,
    required this.city,
    this.bio,
    this.profilePicture,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      userId: json['user_id'],
      skills: json['skills'],
      province: json['province'],
      city: json['city'],
      bio: json['bio'],
      profilePicture: json['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'skills': skills,
      'province': province,
      'city': city,
      'bio': bio,
      'profile_picture': profilePicture,
    };
  }
}