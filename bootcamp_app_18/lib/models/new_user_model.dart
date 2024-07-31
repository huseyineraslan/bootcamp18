class NewUser {
  String? email;
  String? name;
  String? age;
  String? height;
  String? weight;
  String? gender;
  String? additionalInfo;
  String? steps;

  NewUser(
      {required this.email,
      required this.name,
      required this.age,
      required this.height,
      required this.weight,
      required this.additionalInfo,
      required this.gender,
      required this.steps});

  factory NewUser.fromJson(Map<String, dynamic> json) {
    return NewUser(
      email: json['email'],
      name: json['name'],
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
      gender: json['gender'],
      additionalInfo: json['additionalInfo'] ?? '',
      steps: json['steps'],
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
      'steps': steps,
    };
  }

  // ToString metodu
  @override
  String toString() {
    List<String> details = [];

    void addDetail(String label, dynamic value) {
      if (value != null && value.toString().isNotEmpty) {
        details.add('$label: $value');
      }
    }

    addDetail('Yaş', age);
    addDetail('Cinsiyet', gender);
    addDetail('Boy', height != null ? '${height!} cm' : null);
    addDetail('Kilo', weight != null ? '${weight!} kg' : null);
    addDetail('Ek Bilgiler', additionalInfo);

    return details.isEmpty
        ? 'Kullanıcı bilgisi:'
        : 'Kullanıcı Bilgileri:\n${details.join(', ')}';
  }
}
