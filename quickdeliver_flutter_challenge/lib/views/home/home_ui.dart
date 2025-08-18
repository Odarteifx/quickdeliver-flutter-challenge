import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:quickdeliver_flutter_challenge/widgets/home_widgets/deliveries_list.dart';
import 'package:quickdeliver_flutter_challenge/services/notification_service.dart';

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
                  height: 0.1.sp,
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
                      onPressed: () async {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        try {
                          await testLocalNotification();
                          if (mounted) {
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                content: Text('Test notification sent!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text('Error sending test notification: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
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
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ActionBtn(
                          actionlogo: Iconsax.notification_copy,
                          action: 'Test Notification',
                          iconbackground: AppColors.background,
                          backgroundColor: Colors.orange,
                          function: () async {
                            final scaffoldMessenger = ScaffoldMessenger.of(context);
                            try {
                              await testLocalNotification();
                              if (mounted) {
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('Test notification sent! Check your notification panel.'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Error sending test notification: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ActionBtn(
                          actionlogo: Iconsax.info_circle,
                          action: 'Check Status',
                          iconbackground: AppColors.background,
                          backgroundColor: Colors.blue,
                          function: () async {
                            final scaffoldMessenger = ScaffoldMessenger.of(context);
                            try {
                              await checkNotificationStatus();
                              if (mounted) {
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('Check console for notification status details'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Error checking status: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                        SizedBox(width: 8.w),
                        ActionBtn(
                          actionlogo: Iconsax.shield_tick,
                          action: 'Request Permissions',
                          iconbackground: AppColors.background,
                          backgroundColor: Colors.purple,
                          function: () async {
                            final scaffoldMessenger = ScaffoldMessenger.of(context);
                            try {
                              await requestIOSPermissions();
                              if (mounted) {
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('iOS permissions requested. Check console for details.'),
                                    backgroundColor: Colors.purple,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Error requesting permissions: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ActionBtn(
                          actionlogo: Iconsax.notification_copy,
                          action: 'iOS Test Suite',
                          iconbackground: AppColors.background,
                          backgroundColor: Colors.teal,
                          function: () async {
                            final scaffoldMessenger = ScaffoldMessenger.of(context);
                            try {
                              await testIOSNotifications();
                              if (mounted) {
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('iOS test suite completed. Check console and notifications!'),
                                    backgroundColor: Colors.teal,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Error running iOS test suite: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                        ),
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
               DeliveriesList() 
              ],
            ),
          ],
        ),
      ),
    );
  }
}
