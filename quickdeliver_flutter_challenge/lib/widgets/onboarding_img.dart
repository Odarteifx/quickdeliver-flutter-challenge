import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingImg extends StatelessWidget {
  final String img;
  const OnboardingImg({
    super.key,
    required this.img
  });

  @override
  Widget build(BuildContext context,) {
    return Image.asset(img,
        width: 390.w, height: 390.h);
  }
}
