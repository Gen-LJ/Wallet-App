class ExpenseModel {
  int? id;
  String? name;
  int? balance;
  String? time;

  ExpenseModel({this.id, this.name, this.balance, this.time});

  ExpenseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    balance = json['cost'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cost'] = balance;
    data['time'] = time;
    return data;
  }
}