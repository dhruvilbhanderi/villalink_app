class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? flatNumber;
  final String userType;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.flatNumber,
    required this.userType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.tryParse(json['id'].toString()) ?? 0,  // ✅ safe parse
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      flatNumber: json['flat_number']?.toString(),
      userType: json['user_type']?.toString() ?? 'member',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'flat_number': flatNumber,
      'user_type': userType,
    };
  }

  bool get isPresident => userType.toLowerCase() == 'president'; // ✅ safer
  bool get isMember => userType.toLowerCase() == 'member';
}
