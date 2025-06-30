import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_fonts.dart';
import '../../widgets/onboarding_img.dart';

class PageViewTwo extends StatefulWidget {
  const PageViewTwo({super.key});

  @override
  State<PageViewTwo> createState() => _PageViewTwoState();
}

class _PageViewTwoState extends State<PageViewTwo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OnboardingImg(img: 'assets/images/delivery_map.png'),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Text(
            'Real-time Tracking',
            style: GoogleFonts.inter(
                fontSize: AppFonts.heading2, fontWeight: AppFontweight.medium),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Text(
              'Stay updated with live tracking from pick-up to delivery. Know exactly where your package is, get notifications for every milestone, and enjoy complete peace of mind.',
              style: GoogleFonts.inter(
                  fontSize: AppFonts.onboadingbody,
                  fontWeight: AppFontweight.light),
            )),
      ],
    );
  }
}
