class Staff {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? company;

  Staff({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.company,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      company: json['company']?['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'company': company,
    };
  }
}
