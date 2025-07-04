
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_colors.dart';
import '../../core/app_fonts.dart';
import '../home_widgets/status_badge.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.doc,
    required this.orderID,
    required this.status,
    required this.dropOff,
    required this.receiver,
    required this.contact,
  });

  final QueryDocumentSnapshot<Object?> doc;
  final dynamic orderID;
  final dynamic status;
  final dynamic dropOff;
  final dynamic receiver;
  final dynamic contact;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: AppColors.iconColor.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      color: AppColors.background,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () {
          context.push('/orderDetails', extra: doc);
        },
        child: Column(
          spacing: 1.sp,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
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
              padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 5.sp),
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
  }
}
