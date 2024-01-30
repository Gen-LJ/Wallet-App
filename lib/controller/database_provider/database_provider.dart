



import 'package:flutter/cupertino.dart';
import 'package:wallet_app/model/database/balance_db.dart';

class DatabaseProvider extends InheritedWidget {
  const DatabaseProvider({required this.dataBaseHelper, super.key, required super.child});
  final DataBaseHelper dataBaseHelper;

  static DatabaseProvider of(BuildContext context){
    return (context.dependOnInheritedWidgetOfExactType<DatabaseProvider>())!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }


}