
import 'package:flutter/material.dart';
import 'package:wallet_app/model/database/model/balance_model.dart';

import '../../controller/database_provider/database_provider.dart';
import '../balance_transfer/all_balance_screen.dart';

class OldBalance extends StatefulWidget {
  const OldBalance({
    super.key,
    required this.databaseProvider, required this.title, required this.image, required this.email, required this.phNumber, required this.UID,
  });

  final DatabaseProvider databaseProvider;
  final String title;
  final String image;
  final String email;
  final String phNumber;
  final String UID;

  @override
  State<OldBalance> createState() => _OldBalanceState();
}

class _OldBalanceState extends State<OldBalance> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BalanceModel>(
      future: widget.databaseProvider.dataBaseHelper.getAllByUID(widget.UID),
      builder:
          (BuildContext context, AsyncSnapshot<BalanceModel> snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding:
            EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white)),
            child: Column(
              children: [
                Text('Username : ${snapshot.data!.name ?? ''}'),
                Text('ID :${snapshot.data!.id} '),
                Text(
                  'Current balance',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'SGD ${snapshot.data!.balance ?? 0} ',
                  style: TextStyle(
                      fontSize: 21, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10,),
                ElevatedButton(onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AllBalanceScreen(
                    title: widget.title,
                    image: widget.image,
                    email: widget.email,
                    phNumber: widget.phNumber,
                    UID: widget.UID,
                    fromUserID: snapshot.data!.id,
                  )));
                }, child: Text('Trasfer Balance'))
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return const Text("something wrong");
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}