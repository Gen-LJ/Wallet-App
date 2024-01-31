import 'package:flutter/material.dart';
import 'package:wallet_app/model/database/model/balance_model.dart';

import '../../controller/database_provider/database_provider.dart';
import '../balance_transfer/all_balance_screen.dart';

class OldBalance extends StatefulWidget {
  const OldBalance({
    super.key,
    required this.databaseProvider,
    required this.title,
    required this.image,
    required this.email,
    required this.phNumber,
    required this.UID,
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
  int balance = 0;

  @override
  void initState() {
    setState(() {
      widget.databaseProvider.dataBaseHelper
          .getAllByUID(widget.UID)
          .then((value) {
        balance = value.balance!;
      });
    });
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      widget.databaseProvider.dataBaseHelper.getAllByUID(widget.UID);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build method is called');
    final getBalance = widget.databaseProvider.dataBaseHelper.getAllByUID(widget.UID);
    final balanceWidget = FutureBuilder<BalanceModel>(
      key: UniqueKey(),
      future: getBalance,
      builder: (BuildContext context, AsyncSnapshot<BalanceModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          print('This is hasdata');
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                const Text(
                  "Current balance",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'SGD ${snapshot.data!.balance ?? 0} ',
                  style: const TextStyle(
                      fontSize: 21, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      print('This is set');
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllBalanceScreen(
                                    title: widget.title,
                                    image: widget.image,
                                    email: widget.email,
                                    phNumber: widget.phNumber,
                                    UID: widget.UID,
                                    fromUserID: snapshot.data!.id,
                                  ))).then((value) {
                        setState(() {
                          print('This is set state.');
                        });
                      });

                    },
                    child: const Text('Transfer Balance'))
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return const Text("something wrong");
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
    return balanceWidget;
  }
}
