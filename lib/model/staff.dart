class Staff {
  String id;
  String username;
  String email;
  int createdAt;

  Staff(
      {required this.id,
      required this.username,
      required this.email,
      required this.createdAt});

  factory Staff.fromMap(Map<dynamic, dynamic> map) => Staff(
        id: map['id'],
        username: map['username'],
        email: map['email'],
        createdAt: map['createdAt'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'email': email,
        'createdAt': createdAt,
      };
}
