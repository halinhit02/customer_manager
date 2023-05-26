class History {
  String id;
  int amount;
  String description;
  int time;

  History(
      {required this.id,
      required this.amount,
      this.description = '',
      required this.time});

  factory History.fromMap(Map<dynamic, dynamic> map) => History(
        id: map['id'] ?? '',
        amount: map['amount'],
        description: map['description'],
        time: map['time'],
      );

  Map<dynamic, dynamic> toMap() => {
        'id': id,
        'amount': amount,
        'description': description,
        'time': time,
      };
}
