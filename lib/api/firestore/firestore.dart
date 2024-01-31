import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  final CollectionReference products =
  FirebaseFirestore.instance.collection('users');

  Future<void> addUsers(String name,String email,int balance) {
    return products.add({
      'name' : name,
      'email': email,
      'phNo' : balance,
      'timestamp' : Timestamp.now()
    });
  }
  Stream<QuerySnapshot> getUserStream(){
    final userStream =
    products.orderBy('timestamp',descending: true).snapshots();
    return userStream;
  }
}