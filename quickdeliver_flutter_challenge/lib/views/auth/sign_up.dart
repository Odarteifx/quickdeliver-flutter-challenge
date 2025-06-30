import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickdeliver_flutter_challenge/core/app_colors.dart';
import 'package:quickdeliver_flutter_challenge/core/app_fonts.dart';
import 'package:quickdeliver_flutter_challenge/widgets/page_heading.dart';
import 'package:quickdeliver_flutter_challenge/widgets/sub_text.dart';

import '../../widgets/auth_widgets.dart/action_btn.dart';
import '../../widgets/auth_widgets.dart/email_textfield.dart';
import '../../widgets/auth_widgets.dart/name_textfield.dart';
import '../../widgets/auth_widgets.dart/password_textfields.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

String name = '', email = '', password = '', confirmpassword = '';

late final TextEditingController _namecontroller;
late final TextEditingController _emailcontroller;
late final TextEditingController _passwordcontroller;
late final TextEditingController _confirmpasswordcontroller;

class _SignUpState extends State<SignUp> {
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    _namecontroller = TextEditingController();
    _emailcontroller = TextEditingController();
    _passwordcontroller = TextEditingController();
    _confirmpasswordcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _namecontroller.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _confirmpasswordcontroller.dispose();
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
                    width: 50.w,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  const PageHeading(title: 'Create an Account'),
                  
                  const SubText(
                    subtext:
                        'Let\'s make it simple, create your account and join our delivery family today.',
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  NameTextField(controller: _namecontroller),
                  SizedBox(
                    height: 5.h,
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
                  PasswordTextField(
                    controller: _confirmpasswordcontroller,
                    hintText: 'Confirm password',
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  MajorButton(
                    buttonText: 'Sign Up',
                    function: () {},
                  ),
                  Text(
                    'By continuing, you agree to Nova\'s Consumer Terms and Usage Policy, and acknoledge their Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: AppFonts.termsfont),
                  ),
                  SizedBox(
                    height: 15.sp,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an Account?  ',
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                          onTap: () {},
                          child: const Text('Log In',
                              style: TextStyle(color: AppColors.primary)))
                    ],
                  )
                  
                ],
              )),
        ),
      ),
    );
  }
}
