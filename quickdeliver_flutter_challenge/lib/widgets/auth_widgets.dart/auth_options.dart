import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_fonts.dart';

class AuthOption extends StatelessWidget {
  const AuthOption({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.authIcon,
    required this.auth,
    this.onPressed,
  });
  final Color backgroundColor;
  final Color textColor;
  final String authIcon;
  final String auth;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: TextButton(
          onPressed: onPressed ?? () {},
          style: TextButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: const Color(0xFFD6D4D4), width: 1),
                  borderRadius: BorderRadius.circular(10.r))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                authIcon,
                height: 20.h,
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(auth,
                  style: GoogleFonts.poppins(
                      color: textColor, fontWeight: AppFontweight.regular))
            ],
          )),
    );
  }
}
