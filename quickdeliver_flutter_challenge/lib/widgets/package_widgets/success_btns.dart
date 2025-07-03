import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_fonts.dart';

class SuccessBtns extends StatelessWidget {
  const SuccessBtns(
      {super.key,
      required this.buttonText,
      required this.function,
      required this.backgroundColor,
      required this.borderColor,
      required this.textColor});

  final String buttonText;
  final VoidCallback function;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
                side: BorderSide(color: borderColor)),
            backgroundColor: backgroundColor),
        onPressed: function,
        child: Text(
          buttonText,
          style: GoogleFonts.poppins(
              color: textColor,
              fontSize: AppFonts.subtext,
              fontWeight: AppFontweight.semibold),
        ),
      ),
    );
  }
}
