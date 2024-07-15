class User {
  String? email;
  int? age;

  User({required this.email, required this.age});

  // From json
  User.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    age = json["age"];
  }

  // To json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["email"] = email;
    data["age"] = age;
    return data;
  }
}
