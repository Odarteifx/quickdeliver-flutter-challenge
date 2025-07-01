import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickdeliver_flutter_challenge/core/app_colors.dart';
import 'package:quickdeliver_flutter_challenge/core/app_fonts.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;

  const EmailTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your email address';
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: AppFonts.subtext),
      decoration: InputDecoration(
          hintText: 'Email address',
          filled: true,
          fillColor: AppColors.background,
          hintStyle: GoogleFonts.poppins(
              color: AppColors.subtext, fontSize: AppFonts.subtext),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.iconColor),
            borderRadius: BorderRadius.circular(10.r),
          )),
    );
  }
}
