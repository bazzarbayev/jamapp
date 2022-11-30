class OrderCatalog {
  String id;
  int quantity;
  String options;

  OrderCatalog({this.id, this.quantity, this.options});

  OrderCatalog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    options = json['options'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantity'] = this.quantity;
    data['options'] = this.options;
    return data;
  }
}
