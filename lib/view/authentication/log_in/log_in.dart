





import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wallet_app/api/firestore/firestore.dart';


class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 24),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TextFormField(
              //   decoration:  InputDecoration(
              //       prefixIcon: Icon(Icons.email_outlined,),
              //       hintText: 'Email',
              //     border: OutlineInputBorder().copyWith(
              //         borderRadius: BorderRadius.circular(14),
              //         borderSide: const BorderSide(width: 1,color: Colors.grey)
              //     ),
              //   ),
              // ),
              // SizedBox(height: 10,),
              // TextFormField(
              //   decoration:  InputDecoration(
              //       prefixIcon: Icon(Icons.lock_outline_rounded,),
              //       suffixIcon: Icon(Icons.visibility_off),
              //       hintText: 'Password',
              //     border: OutlineInputBorder().copyWith(
              //         borderRadius: BorderRadius.circular(14),
              //         borderSide: const BorderSide(width: 1,color: Colors.grey)
              //     ),
              //   ),
              //
              // ),
              // SizedBox(height: 10,),
              // Container(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //
              //       onPressed: (){
              //
              //   }, child: Text('Log In')),
              // ),
              // Text('Or'),
              // SizedBox(height: 10,),
              Text("Log In with Google"),
              SizedBox(height: 10,),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.grey)
                ),
                child: IconButton(
                  onPressed: (){
                    signInWithGoogle();
                  },
                  icon : const Icon(Icons.g_mobiledata_rounded,size: 32,),
                ),),
            ],
          ),
        ),
      ),
    );
  }

  signInWithGoogle() async {

    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    debugPrint(userCredential.user?.displayName);
    debugPrint(userCredential.user?.phoneNumber);
     debugPrint(userCredential.user?.uid);
  }

  Future addUserDetails(
      String name,String email
      ) async {

  }
}
