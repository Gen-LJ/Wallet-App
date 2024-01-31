import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wallet_app/common/widgets/circular_image.dart';
import 'package:wallet_app/model/database/balance_db.dart';

import '../../../api/firestore/firestore.dart';
import '../../../controller/database_provider/database_provider.dart';
import '../widgets/old_balance.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen(
      {super.key,
      required this.title,
      required this.image,
      required this.email,
      required this.phNumber,
      required this.UID});

  final String title;
  final String image;
  final String email;
  final String phNumber;
  final String UID;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
  late DatabaseProvider databaseProvider;
}

class _ProfileScreenState extends State<ProfileScreen> {
  late DatabaseProvider databaseProvider;
  //final FireStoreService fireStoreService = FireStoreService();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    databaseProvider = DatabaseProvider.of(context);
    // databaseProvider.dataBaseHelper.getUser(widget.UID)!.then((querySnapshot) {
    //   print(querySnapshot['name']);
    //
    // });
    setState(() {
      databaseProvider.dataBaseHelper.getAllBalance();
      databaseProvider.dataBaseHelper.getAllByUID(widget.UID);
    });

    databaseProvider.dataBaseHelper.insertBalance(
        name: widget.title, time: DateTime.now().toString(), balance: 10000,UID: widget.UID);

    //fireStoreService.addUsers(widget.title, widget.email, 10000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,

        // actions: [
        //   IconButton(onPressed: () async{
        //     await GoogleSignIn().signOut();
        //     FirebaseAuth.instance.signOut();
        //   }, icon: Icon(Icons.logout))
        // ],
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              CircularImage(
                imageUrl: widget.image,
                isNetworkImage: true,
              ),
              SizedBox(
                height: 8,
              ),
              Text('Name : ${widget.title}'),
              SizedBox(
                height: 8,
              ),
              Text('Email Address : ${widget.email}'),
              SizedBox(
                height: 8,
              ),
              Text('Phone : ${widget.phNumber}'),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      // databaseProvider.dataBaseHelper
                      //     .insertBalance(
                      //         name: widget.title,
                      //         time: DateTime.now().toString(),
                      //         balance: 10000, UID: widget.UID)
                      //     .catchError((e) {
                      //   print(e);
                      // });
                      await GoogleSignIn().signOut();
                      FirebaseAuth.instance.signOut();
                    },
                    child: Text('Log Out')),
              ),
              SizedBox(
                height: 50,
              ),
              OldBalance(databaseProvider: databaseProvider,
                title: widget.title,
                image: widget.image,
                email: widget.email,
                phNumber: widget.phNumber,
                UID: widget.UID,)
            ],
          ),
        ),
      ),
    );
  }
}

