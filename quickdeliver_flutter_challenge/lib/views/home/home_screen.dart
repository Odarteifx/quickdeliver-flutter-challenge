import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/app_colors.dart';
import '../../core/app_fonts.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

final user = FirebaseAuth.instance.currentUser;
final now = DateTime.now();
final hour = now.hour;

String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour >= 5 && hour < 12) {
    return 'Good morning';
  } else if (hour >= 12 && hour < 17) {
    return 'Good afternoon';
  } else if (hour >= 17 && hour < 21) {
    return 'Good evening';
  } else {
    return 'Good night';
  }
}

// assume this is something like "William Lamptey"

class _AppHomeState extends State<AppHome> {
  String? get displayName => user?.displayName;

  String get greeting =>
      '${getGreeting()}, ${displayName?.split(' ').first ?? 'User'}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.sp,
                ),
                Row(
                  children: [
                    Badge(
                      alignment: Alignment(0.8.sp, 0.40.sp),
                      smallSize: 10.sp,
                      backgroundColor: Colors.green,
                      child: CircleAvatar(
                        backgroundImage: user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : null,
                        child: user?.photoURL == null
                            ? Text(
                                (user?.displayName?.isNotEmpty ?? false)
                                    ? user!.displayName![0].toUpperCase()
                                    : 'U',
                                style: TextStyle(color: Colors.white),
                              )
                            : null,
                      ),
                    ),
                    SizedBox(
                      width: 5.h,
                    ),
                    Text(
                      greeting,
                      style: GoogleFonts.poppins(
                          fontSize: AppFonts.subtext,
                          fontWeight: AppFontweight.medium,
                          color: AppColors.primary),
                    ),
                    Spacer(),
                    IconButton(onPressed: () {}, icon: Icon(Iconsax.scan)),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Iconsax.notification_copy,
                      ),
                      iconSize: 22.sp,
                    )
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Column(
                  spacing: 20.sp,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: GoogleFonts.poppins(
                          fontWeight: AppFontweight.medium,
                          fontSize: AppFonts.onboadingbody),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ActionBtn(
                          actionlogo: Iconsax.box_add_copy,
                          action: 'New Delivery',
                          iconbackground: AppColors.background,
                          backgroundColor: AppColors.primary,
                        ),
                        ActionBtn(actionlogo: Iconsax.location_copy, action: 'Track Location', iconbackground: Colors.white, backgroundColor: Colors.black,)
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

class ActionBtn extends StatelessWidget {
  const ActionBtn({
    super.key,
    required this.actionlogo,
    required this.action,
    required this.iconbackground,
    required this.backgroundColor,
  });
  final IconData actionlogo;
  final String action;
  final Color iconbackground;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10.r),
          onTap: () {},
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: backgroundColor,
                ),
                height: 50.h,
                width: 170.w,
                child: Center(
                    child: Row(
                  // spacing: 10.w,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: iconbackground,
                          borderRadius: BorderRadius.circular(50.r)),
                      child: Padding(
                          padding: EdgeInsets.all(5.0.sp),
                          child: Icon(
                            actionlogo,
                            color: backgroundColor,
                            size: 25.sp,
                          )),
                    ),
                    Text(
                      action,
                      style: GoogleFonts.poppins(
                          color: AppColors.background,
                          fontWeight: AppFontweight.medium),
                    ),
                  ],
                )),
              ),
            ],
          ),
        )
      ],
    );
  }
}
