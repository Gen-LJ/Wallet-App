import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallet_app/model/database/model/transfer_model.dart';

class TransferDataBaseHelper {
  late Database _transferDb;
  final String dbName = 'transfer.db';
  final String transferTable = 'transfer_table';

  Future<void> transferInit() async {
    await _createDatabase();
    await _createBalanceTable();
  }

  Future<Database> _createDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, dbName);
    _transferDb = await openDatabase(path);
    return _transferDb;
  }

  Future<void> _createBalanceTable() async {
    return await _transferDb.execute(
        'create table if not exists $transferTable(id integer primary key,sender text,receiver text,send integer,receive integer,balance integer,time text)');
  }

  Future<List<TransferModel>> getAllTransfer() async {
    List<Map<String, dynamic>> transferMap =
        await _transferDb.rawQuery('select * from $transferTable');
    return transferMap.map((e) {
      return TransferModel.fromJson(e);
    }).toList();
  }

  Future<void> insertTransfer(
      {required String sender,
      required String receiver,
      required bool send,
        required bool receive,
      required int balance,
      required String time}) {
    return _transferDb.execute(
      'insert into $transferTable(sender,receiver,send,receive,balance,time)'
      'values ("$sender","$receiver",$send,$receive,$balance,"$time")',
    );
  }


  Future<List<String>> getDateList() async {
    final rawDateList = await _transferDb.rawQuery('select time from $transferTable');
    final dateList = rawDateList.map((e)  {
      String rawDate = e['time'].toString();
      String date = rawDate.split(' ')[0];
      return date;

    }).toSet().toList();
    return dateList;
  }

  Future<List<Map<String, dynamic>>> getAllTransactions({int? filter}) async {
    Database db = await _transferDb;
    if (filter != null) {
      return await db.query(
        transferTable,
        where: 'send = ?',
        whereArgs: [filter],
        orderBy: 'date DESC',
      );
    } else {
      return await db.query(transferTable, orderBy: 'date DESC');
    }
  }

}


