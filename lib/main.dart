import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_app/controller/transfer_database_provider/transfer_database_provider.dart';
import 'package:wallet_app/model/database/balance_db.dart';
import 'package:wallet_app/view/authentication/log_in/log_in.dart';
import 'package:wallet_app/view/bottom_navigation/bottom_navigation.dart';

import 'controller/bottom_navigation_controller/bot_nav_bloc.dart';
import 'controller/database_provider/database_provider.dart';
import 'firebase_options.dart';
import 'model/database/transfer_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  await dataBaseHelper.init();
  TransferDataBaseHelper transferDataBaseHelper = TransferDataBaseHelper();
  await transferDataBaseHelper.transferInit();
  runApp(MyApp(
    dataBaseHelper: dataBaseHelper,
    transferDataBaseHelper: transferDataBaseHelper,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.dataBaseHelper, required this.transferDataBaseHelper});
  final DataBaseHelper dataBaseHelper;
  final TransferDataBaseHelper transferDataBaseHelper;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BotNavBloc>(
          create: (context) => BotNavBloc(),
        ),
      ],
      child: DatabaseProvider(
        dataBaseHelper: dataBaseHelper,
        child: TransferDatabaseProvider(
          transferDataBaseHelper: transferDataBaseHelper,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data == null) {
                      return LogInScreen();
                    } else {
                      return BottomNavigationScreen(
                        title: FirebaseAuth.instance.currentUser!.displayName!,
                        image: FirebaseAuth.instance.currentUser!.photoURL ?? '',
                        email: FirebaseAuth.instance.currentUser!.email ?? '',
                        phNumber:
                            FirebaseAuth.instance.currentUser!.phoneNumber ??
                                'No Phone Number Added',
                        UID: FirebaseAuth.instance.currentUser!.uid,
                      );
                    }
                  }
                  return CircularProgressIndicator();
                }),
          ),
        ),
      ),
    );
  }
}
