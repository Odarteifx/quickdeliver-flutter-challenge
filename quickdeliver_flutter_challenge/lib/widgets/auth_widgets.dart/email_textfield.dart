import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickdeliver_flutter_challenge/core/app_colors.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;

  const EmailTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your email address';
        } else {
          return null;
        }
      },
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          hintText: 'Enter email address',
          filled: true,
          fillColor: AppColors.background,
          hintStyle: GoogleFonts.inter(color: AppColors.subtext),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.iconColor),
               borderRadius: BorderRadius.circular(12.r),
              )),
    );
  }
}