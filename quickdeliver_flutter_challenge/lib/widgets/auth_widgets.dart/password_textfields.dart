import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/app_colors.dart';
import '../../core/app_fonts.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

bool _hidepassword = true;

class _PasswordTextFieldState extends State<PasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter a valid password';
        } else {
          return null;
        }
      },
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      style: TextStyle(fontSize: AppFonts.subtext),
      obscureText: _hidepassword,
      obscuringCharacter: '*',
      decoration: InputDecoration(
          hintText: widget.hintText,
          filled: true,
          fillColor: AppColors.background,
          prefixIcon: Icon(Iconsax.lock_copy, size: 20,),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _hidepassword = !_hidepassword;
              });
            },
            icon: Icon(
              _hidepassword ? Iconsax.eye_copy : Iconsax.eye_slash_copy,
              size: 22,
            ),
          ),
          hintStyle: GoogleFonts.inter(color: AppColors.subtext, fontSize: AppFonts.subtext),
          border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12.r),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.iconColor),
               borderRadius: BorderRadius.circular(12.r),
               )),
    );
  }
}