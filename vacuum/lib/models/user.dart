class User {
  final int id;
  final String name;
  final String email;
  final String telephone;
  final String role;
  final String? type;
  final String? companyName;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.telephone,
    required this.role,
    this.type,
    this.companyName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      telephone: json['telephone'],
      role: json['role'],
      type: json['type'],
      companyName: json['company_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'telephone': telephone,
      'role': role,
      'type': type,
      'company_name': companyName,
    };
  }
}