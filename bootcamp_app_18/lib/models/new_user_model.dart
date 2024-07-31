class NewUser {
  String? email;
  String? name;
  String? age;
  double? height;
  double? weight;
  String? gender;
  String? additionalInfo;

  NewUser(
      {required this.email,
      required this.name,
      required this.age,
      required this.height,
      required this.weight,
      required this.additionalInfo,
      required this.gender});

  factory NewUser.fromJson(Map<String, dynamic> json) {
    return NewUser(
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

  // ToString metodu
  @override
  String toString() {
    String additionalInfoString =
        additionalInfo != null ? 'Ek Bilgiler: $additionalInfo' : '';

    return 'Kullanıcı Bilgileri:\n'
        'Yaş: ${age ?? 'Bilinmiyor'}, '
        'Cinsiyet: ${gender ?? 'Bilinmiyor'}, '
        'Boy: ${height ?? 0.0} cm, '
        'Kilo: ${weight ?? 0.0} kg'
        '$additionalInfoString';
  }
}
