import 'package:flutter/material.dart';
import 'package:wallet_app/controller/transfer_database_provider/transfer_database_provider.dart';
import 'package:wallet_app/view/bottom_navigation/bottom_navigation.dart';

import '../../controller/database_provider/database_provider.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen(
      {Key? key,
      required this.toUserID,
      required this.fromUserID,
      required this.title,
      required this.image,
      required this.email,
      required this.phNumber,
      required this.UID,
      required this.receiverTitle})
      : super(key: key);
  final int fromUserID;
  final int toUserID;
  final String title;
  final String image;
  final String email;
  final String phNumber;
  final String UID;
  final String receiverTitle;

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  late DatabaseProvider databaseProvider;
  late TransferDatabaseProvider transferDatabaseProvider;
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? _balance;
  bool? _send;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    databaseProvider = DatabaseProvider.of(context);
    transferDatabaseProvider = TransferDatabaseProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                validator: (balance) {
                  if (balance == null || balance.isEmpty) {
                    return 'Please Enter Amount';
                  }
                },
                onSaved: (balance) {
                  _balance = balance;
                  _send = true;
                },
                decoration: const InputDecoration(label: Text('Balance')),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        _formKey.currentState?.save();
                        if (_formKey.currentState?.validate() ?? false) {
                          DateTime now = DateTime.now();
                          int? balance = int.tryParse(_balance!);
                          if (balance != null) {
                            //databaseProvider.dataBaseHelper.insertExpense(name: _name!, cost: cost!, time: now.toString(), category: _category!);
                            performTransfer(
                                widget.fromUserID, widget.toUserID, balance);

                            transferDatabaseProvider.transferDataBaseHelper
                                .insertTransfer(
                                    sender: widget.title,
                                    receiver: widget.receiverTitle,
                                    send: _send!,
                                 receive: _send! ? false : true,
                                    balance: balance,
                                    time: DateTime.now().toString());

                            if (mounted) {
                              databaseProvider.dataBaseHelper
                                  .getAllBalance()
                                  .then((value) {
                                databaseProvider.dataBaseHelper
                                    .getAllByUID(widget.UID);
                              }).whenComplete(() {
                                Navigator.pop(context, true);
                              });

                              // Navigator.pop(context,'inserted');

                              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavigationScreen(title: widget.title, image: widget.image, email: widget.email, phNumber: widget.phNumber, UID: widget.UID)));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Successfully saved')));
                            }
                          }
                        }
                      },
                      child: const Text('Transfer')),
                  SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'))
                ],
              ),
            ],
          ),
        ));
  }

  void performTransfer(int fromUserId, int toUserId, int transferAmount) async {
    // int fromUserId = int.tryParse(fromUserController.text) ?? 0;
    // int toUserId = int.tryParse(toUserController.text) ?? 0;
    //int transferAmount = int.tryParse(amountController.text) ?? 0;

    if (fromUserId > 0 && toUserId > 0 && transferAmount > 0) {
      Map<String, dynamic> fromUser =
          await databaseProvider.dataBaseHelper.getUser(fromUserId);
      Map<String, dynamic> toUser =
          await databaseProvider.dataBaseHelper.getUser(toUserId);

      if (fromUser.isNotEmpty && toUser.isNotEmpty) {
        int fromUserBalance = fromUser['balance'];
        int toUserBalance = toUser['balance'];

        if (fromUserBalance >= transferAmount) {
          int newFromUserBalance = fromUserBalance - transferAmount;
          int newToUserBalance = toUserBalance + transferAmount;

          await databaseProvider.dataBaseHelper
              .updateBalance(fromUserId, newFromUserBalance);
          await databaseProvider.dataBaseHelper
              .updateBalance(toUserId, newToUserBalance);

          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return AlertDialog(
          //       title: Text('Transfer Successful'),
          //       content: Text('Balance transferred successfully.'),
          //       actions: [
          //         TextButton(
          //           onPressed: () {
          //             Navigator.of(context).pop();
          //             setState(() {
          //               databaseProvider.dataBaseHelper.getAllBalance();
          //               databaseProvider.dataBaseHelper.getAllByUID(widget.UID);
          //             });
          //           },
          //           child: Text('OK'),
          //         ),
          //       ],
          //     );
          //   },
          // );
        } else {
          showErrorDialog('Insufficient balance for transfer.');
        }
      } else {
        showErrorDialog('Invalid user IDs.');
      }
    } else {
      showErrorDialog('Please enter valid values.');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
