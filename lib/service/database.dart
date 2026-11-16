import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  
  // Función para actualizar el saldo exacto en Firebase
  Future updateUserWallet(String id, String amount) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"Wallet": amount});
  }
  
}