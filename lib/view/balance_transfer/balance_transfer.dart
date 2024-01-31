import 'package:flutter/material.dart';
import 'package:wallet_app/view/balance_transfer/all_balance_screen.dart';
import 'package:wallet_app/view/widgets/old_balance.dart';

import '../../controller/database_provider/database_provider.dart';

class BalanceTransferScreen extends StatefulWidget {
  const BalanceTransferScreen({super.key, required this.title, required this.image, required this.email, required this.phNumber, required this.UID});
  final String title;
  final String image;
  final String email;
  final String phNumber;
  final String UID;

  @override
  State<BalanceTransferScreen> createState() => _BalanceTransferScreenState();
}

class _BalanceTransferScreenState extends State<BalanceTransferScreen> {
  late DatabaseProvider databaseProvider;
  
  
  
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    databaseProvider = DatabaseProvider.of(context);
    setState(() {
      databaseProvider.dataBaseHelper.getAllBalance();
      databaseProvider.dataBaseHelper.getAllByUID(widget.UID);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Balance Transfer'),
        centerTitle: true,
      ),
      body: Padding(
        
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 20),
        child: Column(children: [
          OldBalance(databaseProvider: databaseProvider,
            title: widget.title,
            image: widget.image,
            email: widget.email,
            phNumber: widget.phNumber,
            UID: widget.UID,),
          SizedBox(height: 8,),
          // ElevatedButton(onPressed: () async {
          //   Navigator.push(context, MaterialPageRoute(builder: (context)=>AllBalanceScreen(
          //     title: widget.title,
          //     image: widget.image,
          //     email: widget.email,
          //     phNumber: widget.phNumber,
          //     UID: widget.UID,
          //   )));
          // }, child: Text('Trasfer Balance'))
        ],),
      ),
    );;
  }
}
