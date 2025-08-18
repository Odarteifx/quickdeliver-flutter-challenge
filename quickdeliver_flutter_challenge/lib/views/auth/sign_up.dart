import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickdeliver_flutter_challenge/core/app_colors.dart';
import 'package:quickdeliver_flutter_challenge/core/app_fonts.dart';
import 'package:quickdeliver_flutter_challenge/widgets/page_heading.dart';
import 'package:quickdeliver_flutter_challenge/widgets/sub_text.dart';

import '../../services/notification_service.dart';
import '../../widgets/auth_widgets/action_btn.dart';
import '../../widgets/auth_widgets/auth_options.dart';
import '../../widgets/auth_widgets/email_textfield.dart';
import '../../widgets/auth_widgets/name_textfield.dart';
import '../../widgets/auth_widgets/password_textfields.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

String name = '', email = '', password = '', confirmpassword = '';

class _SignUpState extends State<SignUp> {
  late final TextEditingController _namecontroller;
  late final TextEditingController _emailcontroller;
  late final TextEditingController _passwordcontroller;
  late final TextEditingController _confirmpasswordcontroller;

  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;

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

  Future<void> registration() async {
    if (_formkey.currentState!.validate()) {
      setState(() => isLoading = true);

      name = _namecontroller.text.trim();
      email = _emailcontroller.text.trim();
      password = _passwordcontroller.text.trim();
      confirmpassword = _confirmpasswordcontroller.text.trim();
      if (password == confirmpassword &&
          _namecontroller.text.isNotEmpty &&
          _emailcontroller.text.isNotEmpty &&
          _passwordcontroller.text.isNotEmpty) {
        try {
          final userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          await FirebaseAuth.instance.currentUser
              ?.updateDisplayName(_namecontroller.text.trim());

          await FirebaseFirestore.instance
              .collection('User')
              .doc(userCredential.user!.uid)
              .set({
            'name': _namecontroller.text.trim(),
            'email': email,
            'id': userCredential.user!.uid,
          });

          await FirebaseAuth.instance.currentUser?.reload();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Center(child: Text('Account Successfully Created'))),
            );
            context.go('/home');
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      'Your password is too simple. Try adding more characters, numbers, or symbols.')));
            }
          } else if (e.code == 'email-already-in-use') {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      'Account already exists. Try logging in or use a different email.')));
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('${e.message}')));
            }
          } // ... (error handling remains the same)
        } catch (e) {
          // Handle any other errors
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${e.toString()}')),
            );
          }
        } finally {
          if (mounted) setState(() => isLoading = false);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
          ),
        );
        setState(() => isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: SafeArea(
          child: Form(
              key: _formkey,
              child: Column(
                spacing: 3.sp,
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
                    buttonText: 'Create Account',
                    function: () {
                      registration();
                    },
                    isLoading: isLoading,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    'By continuing, you agree to QuickDeliver\'s Terms and Usage Policy, and acknoledge their Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: AppFonts.termsfont,
                        fontWeight: AppFontweight.light,
                        color: AppColors.subtext),
                  ),
                  SizedBox(
                    height: 5.sp,
                  ),
                  AuthOption(
                    backgroundColor: AppColors.background,
                    textColor: Colors.black,
                    authIcon: 'assets/icon/google.png',
                    auth: 'Continue with Google',
                    onPressed: () async {},
                  ),
                  SizedBox(
                    height: 2.sp,
                  ),
                  AuthOption(
                    backgroundColor: Colors.black,
                    textColor: AppColors.background,
                    authIcon: 'assets/icon/applelogo.png',
                    auth: 'Continue with Apple',
                  ),
                  SizedBox(
                    height: 5.sp,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an Account?  ',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontWeight: AppFontweight.regular),
                      ),
                      GestureDetector(
                          onTap: () {
                            if (mounted) {
                              context.go('/signin');
                            }
                          },
                          child: Text('Log In',
                              style: GoogleFonts.poppins(
                                  color: AppColors.primary,
                                  fontWeight: AppFontweight.semibold)))
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
