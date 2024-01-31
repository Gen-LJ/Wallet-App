import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model/balance_model.dart';

class DataBaseHelper{
  late Database _balanceDb;
  final String dbName = 'balance.db';
  final String balanceTable='balance_table';

  Future<void> init()async{
    await _createDatabase();
    await _createBalanceTable();

  }

  Future<Database> _createDatabase() async {
    var databasePath = await getDatabasesPath();
    String path= join(databasePath,dbName);
    _balanceDb = await openDatabase(path);
    return _balanceDb;
  }

  Future<void> _createBalanceTable()  async {
    return await _balanceDb.execute('create table if not exists $balanceTable(id integer primary key,name text UNIQUE,time text,balance integer,UID text)');
  }

  Future<void> insertBalance({required String name,required String time,required int balance,required String UID}) {
    return _balanceDb.execute('insert into $balanceTable(name,time,balance,UID)'
        'values ("$name","$time",$balance,"$UID")',
    );
  }

  Future<List<BalanceModel>> getAllBalance() async{
    List<Map<String,dynamic>> balanceMap =await _balanceDb.rawQuery('select * from $balanceTable');
    return balanceMap.map((e) {
      return BalanceModel.fromJson(e);
    }).toList();
  }




  Future<List<String>> getDateList() async {
    final rawDateList = await _balanceDb.rawQuery('select time from $balanceTable');
    final dateList = rawDateList.map((e)  {
      String rawDate = e['time'].toString();
      String date = rawDate.split(' ')[0];
      return date;

    }).toSet().toList();
    return dateList;
  }

  Future<Map<String,dynamic>> balance () async{
    final balance = await _balanceDb.rawQuery('select balance from $balanceTable');
    return balance[0];
  }

  Future<Map<String,dynamic>> balanceByUID (String UID) async{
    final balance = await _balanceDb.rawQuery('select balance from $balanceTable where UID like "$UID%"');
    return balance[0];
  }

  Future<BalanceModel> getAllByUID(String UID) async{
    List<Map<String,dynamic>> balanceMap =await _balanceDb.rawQuery('select * from $balanceTable where UID like "$UID%"');
    return balanceMap.map((e) {
      return BalanceModel.fromJson(e);
    }).toList()[0];
  }



//   Future<Map<String,dynamic>>? getUser(int iD) async{
//     final name = await _balanceDb.rawQuery('select name from $balanceTable where UID = $iD');
//       return name[0];
// }

  Future<Map<String, dynamic>> getUser(int id) async {
    Database db = await _balanceDb;
    List<Map<String, dynamic>> users = await db.query(
      balanceTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    return users.isNotEmpty ? users.first : {};
  }

  Future<int> updateBalance(int id, int newBalance) async {
    Database db = await _balanceDb;
    return await db.update(
      balanceTable,
      {'balance': newBalance},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Future upDateBalance(String senderUID,String receiverUID,int balance,) async{
//     final senderOldBalance = balanceByUID(senderUID).then((value) => null);
//     final senderBalance = await _balanceDb.update(balanceTable, {'balance': (senderOldBalance - balance)});
// }

}