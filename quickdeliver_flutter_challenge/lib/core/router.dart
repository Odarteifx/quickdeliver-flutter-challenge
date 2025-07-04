import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeliver_flutter_challenge/views/auth/sign_in.dart';
import 'package:quickdeliver_flutter_challenge/views/auth/sign_up.dart';
import 'package:quickdeliver_flutter_challenge/views/home/home_screen.dart';
import 'package:quickdeliver_flutter_challenge/views/onboarding/onboarding.dart';
import 'package:quickdeliver_flutter_challenge/views/package/order_details.dart';
import 'package:quickdeliver_flutter_challenge/views/package/sucessful_package.dart';

import '../views/package/new_package.dart';
import '../views/splash/splash.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUp(),
    ),
    GoRoute(
      path: '/signin',
      builder: (context, state) => const SignIn(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const AppHome(),
    ),
    GoRoute(
      path: '/newdelivery',
      builder: (context, state) => NewDelivery(),
    ),
    GoRoute(
      path: '/success',
      builder: (context, state) {
        final orderID = state.extra as String;
        return SucessfulPackage(orderID: orderID);
      },
    ),
    GoRoute(
      path: '/orderDetails',
      builder: (context, state) {
        final order = state.extra as DocumentSnapshot;
        return OrderDetailsScreen(order: order);
      },
    )
  ],
);
