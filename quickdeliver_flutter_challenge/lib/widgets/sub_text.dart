import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickdeliver_flutter_challenge/core/app_colors.dart';
import 'package:quickdeliver_flutter_challenge/core/app_fonts.dart';

class SubText extends StatelessWidget {
  const SubText({super.key, required this.subtext});

  final String subtext;

  @override
  Widget build(BuildContext context) {
    return Text(
      subtext, textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
          fontSize: AppFonts.subtext,
          fontWeight: AppFontweight.regular,
          color: AppColors.subtext),
    );
  }
}
