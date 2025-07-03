import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickdeliver_flutter_challenge/core/app_colors.dart';
import 'package:quickdeliver_flutter_challenge/core/app_fonts.dart';
import 'package:quickdeliver_flutter_challenge/views/onboarding/onboarding_get_started.dart';
import 'package:quickdeliver_flutter_challenge/views/onboarding/onboarding_view_one.dart';
import 'package:quickdeliver_flutter_challenge/views/onboarding/onboarding_view_three.dart';
import 'package:quickdeliver_flutter_challenge/views/onboarding/onboarding_view_two.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  bool onlastpage = false;
  final pages = [
    PageViewOne(),
    PageViewTwo(),
    PageViewThree(),
    OnboardingGetStarted()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
            child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              onPageChanged: (value) {
                setState(() {
                  onlastpage = (value == pages.length - 1);
                });
              },
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return pages[index % pages.length];
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Container(
                  alignment: const Alignment(0, 0.9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      onlastpage
                          ? const TextButton(onPressed: null, child: Text(''))
                          : TextButton(
                              onPressed: () {
                                _controller.jumpToPage(3);
                              },
                              child: Text(
                                'Skip',
                                style: GoogleFonts.poppins(
                                    fontSize: AppFonts.subtext,
                                    color: Colors.black,
                                    fontWeight: AppFontweight.medium),
                              )),
                      SmoothPageIndicator(
                        controller: _controller,
                        count: pages.length,
                        effect: ExpandingDotsEffect(
                            activeDotColor: AppColors.primary,
                            dotWidth: 8.w,
                            dotHeight: 8.h,
                            spacing: 6.w),
                      ),
                      onlastpage
                          ? FilledButton(
                              onPressed: () {
                                if (mounted) {
                                  context.go('/signup');
                                }
                              },
                              style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.r))),
                              child: Text(
                                'Done',
                                style: GoogleFonts.poppins(
                                  fontWeight: AppFontweight.medium,
                                    fontSize: AppFonts.subtext),
                              ))
                          : FilledButton(
                              onPressed: () {
                                _controller.nextPage(
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.easeIn);
                              },
                              style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.r))),
                              child: Text(
                                'Next',
                                style: GoogleFonts.poppins(
                                  fontWeight: AppFontweight.medium,
                                    fontSize: AppFonts.subtext),
                              ))
                    ],
                  )),
            )
          ],
        )));
  }
}
