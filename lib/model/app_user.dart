class AppUser {
  bool isAdmin;
  String adminUid;

  AppUser({required this.isAdmin, required this.adminUid});

  factory AppUser.fromMap(Map<dynamic, dynamic> map) => AppUser(
        isAdmin: map['isAdmin'] ?? false,
        adminUid: map['adminUid'] ?? 'WRONGKEY',
      );

  Map<String, dynamic> toMap() => {
        'isAdmin': isAdmin,
        'adminUid': adminUid,
      };
}
