import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickdeliver_flutter_challenge/core/app_fonts.dart';

class PageHeading extends StatelessWidget {
  const PageHeading({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: AppFonts.heading2,
        fontWeight: AppFontweight.semibold,
      ),
    );
  }
}