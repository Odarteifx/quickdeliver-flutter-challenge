import 'package:flutter/material.dart';
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
           top: 350,
            left: 0,
            right: 0,
            child: Image.asset('assets/logos/qkdeliver.png', height: 100, width: 100,)
            ),
            Positioned(
              bottom: 60,
              left: 180,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
                strokeAlign: -4,
                strokeCap:  StrokeCap.square,
                
              ),
            )
        ],
      ),
    );
  }
}