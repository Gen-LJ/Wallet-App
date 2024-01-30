import 'package:flutter/material.dart';
import 'package:wallet_app/controller/bottom_navigation_controller/bot_nav_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../balance_transfer/balance_transfer.dart';
import '../wallet/profile/profile.dart';
import '../transaction_history/transaction_history.dart';




class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key, required this.title, required this.image, required this.email, required this.phNumber});
final String title;
final String image;
final String email;
final String phNumber;
  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> bodyList = [
      BalanceTransferScreen(),
       ProfileScreen(title: widget.title, image: widget.image,email: widget.email, phNumber: widget.phNumber,),

      TransactionHistoryScreen(),

    ];

    return BlocConsumer<BotNavBloc, BotNavState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    return Scaffold(
      body: bodyList[state.currentIndex],
      bottomNavigationBar: NavigationBar(
        elevation: 0,

        destinations: const [
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Balance Transfer'),
          NavigationDestination(
              icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Transaction History'),
        ],
        selectedIndex: state.currentIndex,
        onDestinationSelected: (index){
          BlocProvider.of<BotNavBloc>(context).add(BotNavigate(index));
        },
      ),
    );
  },
);;
  }
}
