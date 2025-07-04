import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_fonts.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color getBackgroundColor() {
    switch (status) {
      case 'Placed':
        return Colors.amber.withValues(alpha: 0.2);
      case 'Picked Up':
        return Colors.blue.withValues(alpha: 0.2);
      case 'In Transit':
        return Colors.teal.withValues(alpha: 0.2);
      case 'Delivered':
        return Colors.green.withValues(alpha: 0.2);
      case 'Cancelled':
        return Colors.red.withValues(alpha: 0.2);
      default:
        return Colors.grey.withValues(alpha: 0.2);
    }
  }

  Color? getTextColor() {
    switch (status) {
      case 'Placed':
        return Colors.amber[700];
      case 'Picked Up':
        return Colors.blue[700];
      case 'In Transit':
        return Colors.teal[700];
      case 'Delivered':
        return Colors.green[700];
      case 'Cancelled':
        return Colors.red[700]!;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: getBackgroundColor(),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          fontSize: 10.sp,
          fontWeight: AppFontweight.medium,
          color: getTextColor(),
        ),
      ),
    );
  }
}
