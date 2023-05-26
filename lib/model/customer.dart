class Customer {
  Customer({
    this.id = "",
    this.name = "",
    this.phone = "",
    this.address = "",
  });

  String id;
  String name;
  String phone;
  String address;

  factory Customer.fromJson(Map<dynamic, dynamic> json) => Customer(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        address: json["money"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "money": address,
      };

  Customer clone() {
    return Customer(
      id: id,
      name: name,
      phone: phone,
      address: address,
    );
  }
}
