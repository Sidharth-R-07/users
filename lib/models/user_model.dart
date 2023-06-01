class UserModel {
  final String name;
  final String email;
  final int age;

  UserModel({
    required this.name,
    required this.email,
    required this.age,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'age': age,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      age: map['age'] as int,
    );
  }
}
