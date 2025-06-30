import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickdeliver_flutter_challenge/core/app_colors.dart';
import 'package:quickdeliver_flutter_challenge/core/app_fonts.dart';

import '../../widgets/onboarding_img.dart';

class PageViewOne extends StatelessWidget {
  const PageViewOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OnboardingImg(img: 'assets/images/delivery_man.png'),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),

          child:  Wrap(
              children: [
                Text(
                  'Welcome to ',
                  style: GoogleFonts.poppins(
                      fontSize: AppFonts.heading2,
                      fontWeight: AppFontweight.medium),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'QuickDeliver',
                  style: GoogleFonts.poppins(
                      fontSize: AppFonts.heading2,
                      fontWeight: AppFontweight.bold,
                      color: AppColors.primary),
                ),
              ],
            ),
          ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Text(
              'Experience hassle-free deliveries for all your everyday needs. Fast, secure, and always dependable, wherever you are.',
              style: GoogleFonts.poppins(
                  fontSize: AppFonts.onboadingbody,
                  fontWeight: AppFontweight.light),
            )),
      ],
    );
  }
}

