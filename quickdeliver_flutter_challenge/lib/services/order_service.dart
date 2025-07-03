import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> createOrder({
    required String pickupLocation,
    required String dropOffLocation,
    required String receiverName,
    required String receiverPhone,
    required String description,
    required String size,
     String? instructions,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');
     final orderID = generateOrderID();

    await _firestore.collection('Orders').add({
      'orderID': orderID,
      'pickupLocation': pickupLocation,
      'dropOffLocation': dropOffLocation,
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
      'description': description,
      'size': size,
      'instructions': instructions,
      'status': 'Placed',
      'createdAt': FieldValue.serverTimestamp(),
      'userId': user.uid,
    });
     return orderID;
  }
}

String generateOrderID() {
  final now = DateTime.now();
  final datePart = "${now.year.toString().substring(2)}"
      "${now.month.toString().padLeft(2, '0')}"
      "${now.day.toString().padLeft(2, '0')}";
  final randomPart = Random().nextInt(90000) + 10000; 

  return "QD-$datePart-$randomPart";
}