// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quickdeliver_flutter_challenge/core/app_colors.dart';

import '../../core/app_fonts.dart';
import '../../widgets/auth_widgets.dart/action_btn.dart';
import '../../widgets/auth_widgets.dart/auth_options.dart';
import '../../widgets/auth_widgets.dart/email_textfield.dart';
import '../../widgets/auth_widgets.dart/password_textfields.dart';
import '../../widgets/page_heading.dart';
import '../../widgets/sub_text.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

String email = '', password = '';

class _SignInState extends State<SignIn> {
  late final TextEditingController _emailcontroller;
  late final TextEditingController _passwordcontroller;

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailcontroller = TextEditingController();
    _passwordcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: SafeArea(
          child: Form(
              key: _formkey,
              child: Column(
                spacing: 5.sp,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logos/qlogo.png',
                    width: 55.w,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  const PageHeading(title: 'Welcome Back!'),
                  const SubText(subtext: 'Your deliveries, one tap away.'),
                  SizedBox(
                    height: 10.h,
                  ),
                  EmailTextField(controller: _emailcontroller),
                  SizedBox(
                    height: 5.h,
                  ),
                  PasswordTextField(
                    controller: _passwordcontroller,
                    hintText: 'Password',
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  MajorButton(
                    buttonText: 'Log in',
                    function: () {},
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Expanded(child: SizedBox()),
                      InkWell(
                        child: Text(
                          'Forgot password?',
                          style: GoogleFonts.poppins(
                              color: AppColors.subtext,
                              fontSize: AppFonts.termsfont,
                              fontWeight: AppFontweight.regular),
                        ),
                        onTap: () {
                          //forgot password
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.sp,
                  ),
                  Text(
                    'OR',
                    style: GoogleFonts.poppins(
                        fontSize: AppFonts.subtext,
                        fontWeight: AppFontweight.regular),
                  ),
                  SizedBox(
                    height: 2.sp,
                  ),
                  AuthOption(
                    backgroundColor: AppColors.background,
                    textColor: Colors.black,
                    authIcon: 'assets/icon/google.png',
                    auth: 'Continue with Google',
                  ),
                  SizedBox(
                    height: 5.sp,
                  ),
                  AuthOption(
                    backgroundColor: Colors.black,
                    textColor: AppColors.background,
                    authIcon: 'assets/icon/applelogo.png',
                    auth: 'Continue with Apple',
                  ),
                  SizedBox(
                    height: 15.sp,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don’t have an account?   ',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontWeight: AppFontweight.regular),
                      ),
                      GestureDetector(
                          onTap: () {
                            context.go('/signup');
                          },
                          child: Text('Sign Up',
                              style: GoogleFonts.poppins(
                                  color: AppColors.primary,
                                  fontWeight: AppFontweight.semibold))),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
