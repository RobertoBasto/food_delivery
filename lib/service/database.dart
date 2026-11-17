import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  
  // Función para actualizar el saldo exacto en Firebase
  Future updateUserWallet(String id, String amount) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"Wallet": amount});
  }
   
  // Función para agregar comida a una categoría específica
  Future addFoodItem(Map<String, dynamic> userInfoMap, String name) async {
    return await FirebaseFirestore.instance
        .collection(name) // será la categoría (Pizza, Burger, etc.)
        .add(userInfoMap);
  }


  // Función para obtener los artículos de comida en tiempo real
  Future<Stream<QuerySnapshot>> getFoodItem(String name) async {
    return FirebaseFirestore.instance.collection(name).snapshots();
  }

  // Función para agregar comida al carrito del usuario
  Future addFoodToCart(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('cart')
        .add(userInfoMap);
  }
}