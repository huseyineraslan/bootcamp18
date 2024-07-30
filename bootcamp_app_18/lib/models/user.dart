class User {
  String email;
  String name;
  String age;
  double height;
  double weight;
  String gender;
  String additionalInfo;

  User(
      {required this.email,
      required this.name,
      required this.age,
      required this.height,
      required this.weight,
      required this.additionalInfo,
      required this.gender});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      name: json['name'],
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
      gender: json['gender'],
      additionalInfo: json['additionalInfo'] ?? '', // Eğer null ise boş string,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'additionalInfo': additionalInfo,
    };
  }
}
