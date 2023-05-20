class Customer {
  Customer(
      {this.id = "",
        this.name = "",
        this.phone = "",
        this.address = "",
        this.note = ""});

  String id;
  String name;
  String phone;
  String address;
  String note;

  factory Customer.fromJson(Map<dynamic, dynamic> json) => Customer(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    address: json["money"],
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "money": address,
    "note": note,
  };

  Customer clone() {
    return Customer(id: id, name: name, phone: phone, address: address, note: note);
  }

  @override
  String toString() {
    return '{id: $id, name: $name, phone: $phone, money: $address, note: $note}';
  }
}