class History {
  int amount;
  String description;
  int time;

  History({required this.amount, this.description = '', required this.time});

  factory History.fromMap(Map<dynamic, dynamic> map) => History(
        amount: map['amount'],
        description: map['description'],
        time: map['time'],
      );

  Map<dynamic, dynamic> toMap() => {
        'amount': amount,
        'description': description,
        'time': time,
      };
}
