class Notification {
  String id;
  String title;
  String content;
  int createdAt;

  Notification({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });


  factory Notification.fromMap(Map<dynamic, dynamic> map) => Notification(
        id: map['id'],
        title: map['title'],
        content: map['content'],
        createdAt: map['createdAt'],
      );


  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt,
      };
}
