import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 5),
    (){
      if (mounted) {
        context.go('/onboarding');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/welcome_image.jpg', fit: BoxFit.cover,),
          Positioned(
           top: 350.sp,
            left: 0,
            right: 0,
            child: Image.asset('assets/logos/qkdeliver.png', height: 100.h, width: 100.w,)
            ),
            Positioned(
              bottom: 60.sp,
              left: 180.sp,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5.r,
                strokeAlign: -4.sp,
                strokeCap:  StrokeCap.square,
                
              ),
            )
        ],
      ),
    );
  }
}