import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickdeliver_flutter_challenge/core/app_fonts.dart';
import 'package:quickdeliver_flutter_challenge/widgets/package_widgets/success_btns.dart';

import '../../core/app_colors.dart';

class SucessfulPackage extends StatelessWidget {
  const SucessfulPackage({super.key, required this.orderID});

  final String orderID;

  Future<DocumentSnapshot> fetchOrder() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Orders')
        .where('orderID', isEqualTo: orderID)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      throw Exception('Order not found');
    }

    return snapshot.docs.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20.h,
          children: [
            Spacer(),
            Image.asset(
              'assets/icon/success_icon.png',
              width: 250.w,
            ),
            Text(
              'Success!',
              style: GoogleFonts.poppins(
                  fontSize: AppFonts.heading1, fontWeight: AppFontweight.bold),
            ),
            Text(
              'Your delivery has been booked',
              style: GoogleFonts.poppins(
                  fontSize: AppFonts.onboadingbody, fontWeight: AppFontweight.medium),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.h,
              children: [
                Text('Order ID:',
                    style: GoogleFonts.poppins(
                        fontSize: AppFonts.onboadingbody,
                        fontWeight: AppFontweight.semibold)),
                Text(
                  orderID,
                  style: GoogleFonts.poppins(
                    fontSize: AppFonts.onboadingbody,
                    color: Colors.blueAccent,
                    fontWeight: AppFontweight.extrabold,
                  ),
                ),
              ],
            ),
            Spacer(),
            SuccessBtns(
                buttonText: 'View Order Details',
                function: () async {
                  try {
                    final doc = await fetchOrder();
                    if (context.mounted) {
                      context.push('/orderDetails', extra: doc);
                    }
                  } catch (e) {
                    if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                    }
                  }
                },
                backgroundColor: AppColors.background,
                borderColor: AppColors.primary,
                textColor: AppColors.primary),
            SuccessBtns(
                buttonText: 'Back to Home',
                function: () {
                  context.go('/home');
                },
                backgroundColor: AppColors.primary,
                borderColor: AppColors.primary,
                textColor: AppColors.background),
          ],
        ),
      )),
    );
  }
}
