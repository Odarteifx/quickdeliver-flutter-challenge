import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickdeliver_flutter_challenge/widgets/home_widgets/status_badge.dart';

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
                elevation: 0,
                margin: EdgeInsets.symmetric(vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(
                    color: AppColors.iconColor.withValues(alpha: 0.6)
                        , // your border color
                    width: 1, // border thickness
                  ),
                ),
                color: AppColors.background,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: () {},
                  child: Column(
                    spacing: 1.sp,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.sp, vertical: 10.sp),
                        child: Row(
                          children: [
                            Text(
                              'Order ID: ',
                              style: GoogleFonts.poppins(
                                  fontSize: AppFonts.termsfont,
                                  fontWeight: AppFontweight.bold),
                            ),
                            Text(
                              ' $orderID',
                              style: GoogleFonts.poppins(
                                  fontSize: AppFonts.termsfont,
                                  fontWeight: AppFontweight.bold,
                                  color: AppColors.subtext),
                            ),
                            Spacer(),
                            StatusBadge(status: status)
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
                            Expanded(
                              child: Column(
                                spacing: 10.h,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Drop off: ',
                                          style: GoogleFonts.poppins(
                                            fontSize: AppFonts.subtext,
                                            fontWeight: AppFontweight.semibold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: dropOff,
                                          style: GoogleFonts.poppins(
                                            fontSize: AppFonts.subtext,
                                            fontWeight: AppFontweight.regular,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        receiver,
                                        style: GoogleFonts.poppins(
                                            fontWeight: AppFontweight.medium),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        contact,
                                        style: GoogleFonts.poppins(
                                            fontWeight: AppFontweight.semibold,
                                            color: AppColors.subtext),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
