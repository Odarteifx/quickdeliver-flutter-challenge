import 'package:flutter/material.dart';

class PageViewOne extends StatelessWidget {
  const PageViewOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset('assets/images/delivery_man.png', width: 390, height: 390),
          Text('Welcome to QuickDeliver')
          
        ],
      ),
    );
  }
}
