import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_colors.dart';
import '../../core/app_fonts.dart';
import '../package_widgets/order_tile.dart';

class DeliveriesList extends StatelessWidget {
  const DeliveriesList({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text('You must be logged in'),
      );
    }

    final ordersStream = FirebaseFirestore.instance
        .collection('Orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: ordersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                  child: Text(
                'No deliveries yet',
                style: GoogleFonts.poppins(
                    fontSize: AppFonts.subtext,
                    fontWeight: AppFontweight.medium,
                    color: AppColors.iconColor),
              )),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final doc = orders[index];
              final orderID = doc['orderID'];
              final dropOff = doc['dropOffLocation'];
              final status = doc['status'];
              final receiver = doc['receiverName'];
              final contact = doc['receiverPhone'];

              return OrderTile(
                  doc: doc,
                  orderID: orderID,
                  status: status,
                  dropOff: dropOff,
                  receiver: receiver,
                  contact: contact);
            },
          );
        },
      ),
    );
  }
}
