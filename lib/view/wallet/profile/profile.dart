import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wallet_app/common/widgets/circular_image.dart';
import 'package:wallet_app/model/database/balance_db.dart';

import '../../../controller/database_provider/database_provider.dart';

class ProfileScreen extends StatefulWidget {
   ProfileScreen({super.key, required this.title, required this.image, required this.email, required this.phNumber});

  final String title;
  final String image;
  final String email;
  final String phNumber;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
  late DatabaseProvider databaseProvider;
}


class _ProfileScreenState extends State<ProfileScreen> {
  late DatabaseProvider databaseProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    databaseProvider = DatabaseProvider.of(context);
    databaseProvider.dataBaseHelper.insertBalance(name: widget.title, balance: 10000, time: DateTime.now().toString());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',style: TextStyle(fontWeight: FontWeight.bold),),
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
          padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 20),
          child: Column(
            children: [
              CircularImage(imageUrl: widget.image,isNetworkImage: true,),
              SizedBox(height: 8,),
              Text('Name : ${widget.title}'),
              SizedBox(height: 8,),
              Text('Email Address : ${widget.email}'),
              SizedBox(height: 8,),
              Text('Phone : ${widget.phNumber}'),
              SizedBox(height: 10,),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: ()async{
                  await GoogleSignIn().signOut();
                  FirebaseAuth.instance.signOut();
                }, child: Text('Log Out')),
              ),
              SizedBox(height: 50,),
              FutureBuilder(
                future: databaseProvider.dataBaseHelper.balance(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(snapshot.hasData) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 20),
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                      border:  Border.all(color: Colors.white) ),
                  child: Column(
                    children:[
                      Text('${snapshot.data['name'] ?? ''}'),
                      Text('Current balance',style: TextStyle(color: Colors.grey),),

                      Text('SGD ${snapshot.data['balance'] ?? 0} ',style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                );
                  }
                  else if(snapshot.hasError){
                    return const Text("something wrong");
                  }
                  return const Center(child: CircularProgressIndicator());},
              )
            ],
          ),
        ),
      ),
    );
  }
}
