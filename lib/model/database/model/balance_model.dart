class BalanceModel {
  int? id;
  String? name;
  String? time;
  int? balance;
  String? UID;

  BalanceModel({this.id, this.name,  this.time ,this.balance ,this.UID});

  BalanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    time = json['time'];
    balance = json['balance'];
    UID = json['UID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['time'] = time;
    data['balance'] = balance;
    data['UID'] = UID;
    return data;
  }
}