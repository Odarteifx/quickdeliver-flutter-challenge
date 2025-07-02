import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/app_colors.dart';
import '../../core/app_fonts.dart';
import '../../widgets/home_widgets/major_btns.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
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

class _HomePageState extends State<HomePage> {
  String? get displayName => user?.displayName;

  String get greeting =>
      '${getGreeting()}, ${displayName?.split(' ').first ?? 'User'}';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Stack(
          children: [
            Column(
              spacing: 20.h,
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
                Column(
                  spacing: 10.sp,
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
                          function: (){
                            context.push('/newdelivery');
                          },
                        ),
                        ActionBtn(
                          actionlogo: Iconsax.box_search_copy,
                          action: 'Track Package',
                          iconbackground: Colors.white,
                          backgroundColor: Colors.black,
                          function:(){
                            
                          },
                        )
                      ],
                    ),
                  ],
                ),
                Text(
                  'Your Deliveries',
                  style: GoogleFonts.poppins(
                      fontSize: AppFonts.onboadingbody,
                      fontWeight: AppFontweight.medium),
                ),
                SizedBox(
                  height: 10.sp,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                        child: Text(
                      'No deliveries yet',
                      style:
                          GoogleFonts.poppins(
                            fontSize: AppFonts.subtext,
                            fontWeight: AppFontweight.medium,
                            color: AppColors.iconColor
                            ),
                    )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
