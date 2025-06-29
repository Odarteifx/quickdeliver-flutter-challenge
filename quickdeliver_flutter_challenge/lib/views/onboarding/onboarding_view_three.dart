import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_fonts.dart';
import '../../widgets/onboarding_img.dart';

class PageViewThree extends StatelessWidget {
  const PageViewThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OnboardingImg(img: 'assets/images/customer_recieve.png'),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Text(
            'Safe, Reliable & Affordable',
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
              'Every delivery matters to us.',
              style: GoogleFonts.roboto(
                  fontSize: AppFonts.onboadingbody,
                  fontWeight: AppFontweight.light),
            )),
            Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Text(
              'Our vetted riders, secure packaging, and competitive rates ensure your parcels arrive safely and on time — without breaking the bank.',
              style: GoogleFonts.roboto(
                  fontSize: AppFonts.onboadingbody,
                  fontWeight: AppFontweight.light),
            )),
      ],
    );
  }
}