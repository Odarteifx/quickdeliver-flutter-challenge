import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickdeliver_flutter_challenge/core/app_colors.dart';
import 'package:quickdeliver_flutter_challenge/core/app_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeliver_flutter_challenge/views/home/home_ui.dart';

import '../../widgets/package_widgets/success_btns.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    return await FirebaseFirestore.instance
        .collection('User')
        .doc(user.uid)
        .get();
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      context.go('/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontWeight: AppFontweight.semibold,
            fontSize: AppFonts.heading2,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No user data found.'));
          }

          final userData = snapshot.data!.data()!;
          final name = userData['name'] ?? 'N/A';
          final email = userData['email'] ?? 'N/A';

          return Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40.r,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? Text(
                          (user?.displayName?.isNotEmpty ?? false)
                              ? user!.displayName![0].toUpperCase()
                              : 'U',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.sp,
                              fontWeight: AppFontweight.bold),
                        )
                      : null,
                ),
                SizedBox(height: 20.h),
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: AppFonts.heading2,
                    fontWeight: AppFontweight.semibold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  email,
                  style: GoogleFonts.poppins(
                    fontSize: AppFonts.onboadingbody,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),

                SuccessBtns(
                    buttonText: 'Logout',
                    function: () {
                      logout(context);
                    },
                    backgroundColor: AppColors.primary,
                    borderColor: AppColors.primary,
                    textColor: AppColors.background),
              ],
            ),
          );
        },
      ),
    );
  }
}
