import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_colors.dart';

class NameTextField extends StatelessWidget {
  final TextEditingController controller;

  const NameTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your name';
        } else {
          return null;
        }
      },
      controller: controller,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
          hintText: 'Full Name',
          filled: true,
          fillColor: AppColors.background,
          hintStyle: GoogleFonts.inter(color: AppColors.subtext),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          enabledBorder:  OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.iconColor),
            borderRadius: BorderRadius.circular(12.r),
          )),
    );
  }
}
