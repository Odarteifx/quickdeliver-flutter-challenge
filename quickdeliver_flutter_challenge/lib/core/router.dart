import 'package:go_router/go_router.dart';
import 'package:quickdeliver_flutter_challenge/views/auth/sign_in.dart';
import 'package:quickdeliver_flutter_challenge/views/auth/sign_up.dart';
import 'package:quickdeliver_flutter_challenge/views/onboarding/onboarding.dart';

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
    )
  ],
);
