
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_colors.dart';
import '../../core/app_fonts.dart';

class ActionBtn extends StatelessWidget {
  const ActionBtn({
    super.key,
    required this.actionlogo,
    required this.action,
    required this.iconbackground,
    required this.backgroundColor,
  });
  final IconData actionlogo;
  final String action;
  final Color iconbackground;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10.r),
          onTap: () {},
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: backgroundColor,
                ),
                height: 50.h,
                width: 170.w,
                child: Center(
                    child: Row(
                  // spacing: 10.w,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: iconbackground,
                          borderRadius: BorderRadius.circular(50.r)),
                      child: Padding(
                          padding: EdgeInsets.all(5.0.sp),
                          child: Icon(
                            actionlogo,
                            color: backgroundColor,
                            size: 25.sp,
                          )),
                    ),
                    Text(
                      action,
                      style: GoogleFonts.poppins(
                          color: AppColors.background,
                          fontWeight: AppFontweight.medium),
                    ),
                  ],
                )),
              ),
            ],
          ),
        )
      ],
    );
  }
}
