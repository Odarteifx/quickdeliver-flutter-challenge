import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_colors.dart';
import '../../core/app_fonts.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color getBackgroundColor() {
    switch (status) {
      case 'Placed':
        return Colors.grey.withValues(alpha: 0.15);
      case 'Delivered':
        return Colors.green.withValues(alpha: 0.15);
      case 'Cancelled':
        return Colors.red.withValues(alpha: 0.15);
      default:
        return Colors.grey.withValues(alpha: 0.15);
    }
  }

  Color getTextColor() {
    switch (status) {
      case 'Placed':
        return Colors.grey;
      case 'Delivered':
        return Colors.green.shade700;
      case 'Cancelled':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
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
          fontSize: AppFonts.termsfont,
          fontWeight: AppFontweight.medium,
          color: getTextColor(),
        ),
      ),
    );
  }
}
