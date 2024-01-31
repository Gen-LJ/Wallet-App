import 'package:flutter/material.dart';
import 'package:wallet_app/model/database/transfer_db.dart';

class TransferDatabaseProvider extends InheritedWidget {
  const TransferDatabaseProvider({required this.transferDataBaseHelper, super.key, required super.child});
  final TransferDataBaseHelper transferDataBaseHelper;

  static TransferDatabaseProvider of(BuildContext context){
    return (context.dependOnInheritedWidgetOfExactType<TransferDatabaseProvider>())!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }


}