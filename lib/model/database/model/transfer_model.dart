class TransferModel {
  int? id;
  String? sender;
  String? receiver;
  int? send;
  int? receive;
  int? balance;
  String? time;

  TransferModel(
      {this.id, this.sender, this.receiver, this.send,this.receive, this.balance, this.time});

  TransferModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sender = json['sender'];
    receiver = json['receiver'];
    send = json['send'];
    receive = json['receive'];
    balance = json['balance'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender'] = sender;
    data['receiver'] = receiver;
    data['send'] = send;
    data['receive'] = receive;
    data['balance'] = balance;
    data['time'] = time;

    return data;
  }
}
