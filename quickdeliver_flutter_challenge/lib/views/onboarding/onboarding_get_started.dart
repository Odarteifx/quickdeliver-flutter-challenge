import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_fonts.dart';
import '../../widgets/onboarding_img.dart';

class OnboardingGetStarted extends StatelessWidget {
  const OnboardingGetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OnboardingImg(img: 'assets/images/get_started.png'),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Text(
            'Ready to Deliver Faster?',
            style: GoogleFonts.roboto(
                fontSize: AppFonts.heading2, fontWeight: AppFontweight.medium),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Text(
              'Sign up in seconds, set your pick-up and drop-off, and experience how quick and easy delivery can truly be.',
              style: GoogleFonts.roboto(
                  fontSize: AppFonts.onboadingbody,
                  fontWeight: AppFontweight.light),
            )),
      ],
    );
  }
}
