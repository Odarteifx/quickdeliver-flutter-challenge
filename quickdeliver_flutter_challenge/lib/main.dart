import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'QuickDeliver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(255, 193, 7, 1)),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}

