import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickdeliver_flutter_challenge/core/app_fonts.dart';

import '../../core/app_colors.dart';

class MajorButton extends StatelessWidget {
  const MajorButton({
    super.key,
    required this.buttonText,
    required this.function,
    this.isLoading = false,
  });

  final String buttonText;
  final VoidCallback function;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            backgroundColor: AppColors.primary),
        onPressed: isLoading ? null : function,
        child:isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2.5,
                ),
              ) : Text(
          buttonText,
          style: GoogleFonts.poppins(
              fontSize: AppFonts.subtext, fontWeight: AppFontweight.semibold),
        ),
      ),
    );
  }
}
