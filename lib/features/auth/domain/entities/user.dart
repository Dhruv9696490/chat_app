class User {
  final String uid;
  final String email;
  final String? name;

  User({required this.uid, required this.email, this.name});

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email, 'name': name};
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
    );
  }
}
