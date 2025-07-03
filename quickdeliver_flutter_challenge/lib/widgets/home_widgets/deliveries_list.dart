import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_colors.dart';
import '../../core/app_fonts.dart';

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
              // final pickup = doc['pickupLocation'];
              final dropOff = doc['dropOffLocation'];
              final status = doc['status'];
              final receiver = doc['receiverName'];
              final contact = doc['receiverPhone'];

              return Card(
                color: AppColors.background,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.sp, vertical: 8.sp),
                      child: Row(
                        children: [
                          Text(
                            'Order ID: ',
                            style: GoogleFonts.poppins(
                                fontSize: AppFonts.termsfont,
                                fontWeight: AppFontweight.medium),
                          ),
                          Text(
                            ' $orderID',
                            style: GoogleFonts.poppins(
                                fontSize: AppFonts.termsfont,
                                fontWeight: AppFontweight.bold,
                                color: AppColors.primary),
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(),
                            child: Text(status),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColors.iconColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.sp, vertical: 5.sp),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                 'Drop off: $dropOff',
                                style: GoogleFonts.poppins(
                                    fontWeight: AppFontweight.semibold),
                              ),
                              Row(
                                children: [
                                  Text(receiver),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(contact)
                                ],
                              )
                            ],
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.primary,
                            size: 15.sp,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
              // return Card(
              //   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //   child: ListTile(
              //     leading: const Icon(Icons.local_shipping),
              //     title: Text('Order: $orderID'),
              //     subtitle: Text('Pickup: $pickup\nDrop-off: $dropOff\nStatus: $status'),
              //     trailing: Icon(Icons.arrow_forward_ios),
              //     onTap: () {

              //     },
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}
