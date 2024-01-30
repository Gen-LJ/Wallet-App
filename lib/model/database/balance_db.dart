import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    return await _balanceDb.execute('create table if not exists $balanceTable(id integer primary key,name text,balance integer,time text)');
  }

  Future<void> insertBalance({required String name,required int balance,required String time}){
    return _balanceDb.execute('insert into $balanceTable(name,balance,time)'
        'values ("$name",$balance,"$time")');
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

}