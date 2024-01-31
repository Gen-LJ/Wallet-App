import 'package:flutter/material.dart';
import 'package:wallet_app/view/balance_transfer/save_screen.dart';

import '../../controller/database_provider/database_provider.dart';
import '../../model/database/model/balance_model.dart';

class AllBalanceScreen extends StatefulWidget {
  const AllBalanceScreen(
      {super.key,
      required this.title,
      required this.image,
      required this.email,
      required this.phNumber,
      required this.UID, this.fromUserID});
  final fromUserID;
  final String title;
  final String image;
  final String email;
  final String phNumber;
  final String UID;

  @override
  State<AllBalanceScreen> createState() => _AllBalanceScreenState();
}

class _AllBalanceScreenState extends State<AllBalanceScreen> {
  late DatabaseProvider databaseProvider;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    databaseProvider = DatabaseProvider.of(context);
    databaseProvider.dataBaseHelper.getAllBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Account to transfer'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<BalanceModel>>(
                future: databaseProvider.dataBaseHelper.getAllBalance(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<BalanceModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    if (snapshot.hasData) {
                      List<BalanceModel> balanceList = snapshot.data ?? [];
                      return ListView.builder(
                          itemCount: balanceList.length,
                          itemBuilder: (context, index) {
                            BalanceModel balanceModel = balanceList[index];
                            return widget.UID != balanceModel.UID ?
                              Card(
                              child: ListTile(
                                onTap: () async {
                                  if(widget.UID != balanceModel.UID){
                                    String? dialogResult = await showDialog(
                                        context: context,
                                        builder: (context){
                                          return  AlertDialog(
                                            title: Text('Enter Balance'),
                                            content: SaveScreen(toUserID: balanceModel.id!, fromUserID: widget.fromUserID,
                                              title: widget.title,
                                              image: widget.image,
                                              email: widget.email,
                                              phNumber: widget.phNumber,
                                              UID: widget.UID,
                                            ),
                                          );
                                        });
                                    if(dialogResult == 'inserted'){
                                      setState(() {
                                        databaseProvider.dataBaseHelper.getAllBalance();
                                        databaseProvider.dataBaseHelper.getAllByUID(widget.UID);
                                      });
                                    }
                                  }
                                  else
                                    {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(content: Text('You cannot Transfer to your own account')));
                                    }
                                },
                                title: Text(
                                    ' Username : ${balanceModel.name ?? ''} '),
                              ),
                            ) : Card(
                                child: ListTile(
                                onTap: () {
                              if(widget.UID != balanceModel.UID){

                              }
                              else
                              {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(content: Text('You cannot Transfer to your own account')));
                              }
                            },
                            title: Text(
                            'My Account : ${balanceModel.name ?? ''} '),
                                  subtitle: Text('Balance : SGD ${balanceModel.balance.toString()}'),
                            ));
                          });
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );


}


}


