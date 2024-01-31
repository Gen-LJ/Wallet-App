import 'package:flutter/material.dart';
import 'package:wallet_app/model/database/model/transfer_model.dart';

import '../../controller/database_provider/database_provider.dart';
import '../../controller/transfer_database_provider/transfer_database_provider.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late TransferDatabaseProvider transferDatabaseProvider;
  int filter = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    transferDatabaseProvider = TransferDatabaseProvider.of(context);
    transferDatabaseProvider.transferDataBaseHelper.getAllTransfer();

  }

  @override
  Widget build(BuildContext context) {
    //Future<List<String>> dateList = transferDatabaseProvider.transferDataBaseHelper.getDateList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 20),
        child: FutureBuilder<List<TransferModel>>(
          future: transferDatabaseProvider.transferDataBaseHelper.getAllTransfer(),
          builder: (BuildContext context, AsyncSnapshot<List<TransferModel>> snapshot) {
            if(snapshot.hasData) {

              print('Snapshot has data');
              List<TransferModel> transferList = snapshot.data ?? [];
              return Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Text('Filter'),
                        SizedBox(width: 10,),
                        _buildFilterButtons(),
                      ],
                    ),
                  ) ,
                  Expanded(
                    child: ListView.builder(
                      itemCount: transferList.length,
                      itemBuilder: (context,index){
                        TransferModel transferModel = transferList[index];
                        DateTime? time = DateTime.tryParse(transferModel.time?? '');
                        return Card(
                          child: ListTile(
                            isThreeLine: true,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('From ${transferModel.sender!}'),
                                Text('To ${transferModel.receiver!}'),
                              ],
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Amount : ${transferModel.balance}'),
                                if(time!= null)
                              Text('${time.day}/${time.month}/${time.year} ${time.hour}:${time.second}'),
                              ],
                            ),

                          ),
                        );
                      }),
                  ),
                ],
              );
            }
            else if (snapshot.hasError) {
              return Center(child: const Text("something wrong"));
            }
            return Center(child: CircularProgressIndicator(),);

          },
        ),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => _applyFilter(0),
          child: Text('In'),
        ),
        ElevatedButton(
          onPressed: () => _applyFilter(1),
          child: Text('Out'),
        ),
        ElevatedButton(
          onPressed: () => _applyFilter(filter),
          child: Text('All'),
        ),
      ],
    );
  }

  void _applyFilter(int selectedFilter) {
    setState(() {
      filter = selectedFilter;
    });
  }
}
