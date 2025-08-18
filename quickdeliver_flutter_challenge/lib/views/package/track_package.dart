import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickdeliver_flutter_challenge/core/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_fonts.dart';

class TrackPackage extends StatefulWidget {
  const TrackPackage({super.key});

  @override
  State<TrackPackage> createState() => _TrackPackageState();
}

class _TrackPackageState extends State<TrackPackage> {
  final TextEditingController _trackingController = TextEditingController();
  bool _isLoading = false;

  Future<void> _getPackage(String input) async {
    final String query = input.trim();
    if (query.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a package number')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .where('orderID', isEqualTo: query)
          .limit(1)
          .get();

      if (!mounted) return;

      if (snapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Package not found')),
        );
      } else {
        final doc = snapshot.docs.first;
        context.push('/orderDetails', extra: doc);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }

  }

  @override
  void dispose() {
    _trackingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          "Track Package",
          style: GoogleFonts.poppins(
            fontWeight: AppFontweight.semibold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Column(
            children: [
              SizedBox(height: 10.h,),
              TextFormField(
                 controller: _trackingController,
                 style: TextStyle(fontSize: AppFonts.subtext),
                 autovalidateMode: AutovalidateMode.onUserInteraction,
                 decoration: InputDecoration(
                     hintText: 'Package Number',
                     filled: true,
                     fillColor: AppColors.background,
                     hintStyle: GoogleFonts.poppins(
                         color: AppColors.subtext, fontSize: AppFonts.subtext),
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10.r),
                     ),
                     enabledBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: AppColors.iconColor),
                       borderRadius: BorderRadius.circular(10.r),
                     ),
                     suffixIcon: _isLoading
                         ? Padding(
                             padding: EdgeInsets.all(10.sp),
                             child: SizedBox(
                               width: 18.sp,
                               height: 18.sp,
                               child: const CircularProgressIndicator(strokeWidth: 2),
                             ),
                           )
                         : IconButton(
                             icon: const Icon(Icons.search),
                             onPressed: () => _getPackage(_trackingController.text),
                           ),
                 ),
                 validator: (value) {
                   if (value == null || value.isEmpty) {
                     return 'Invalid Package Number';
                   }
                   return null;
                 },
                 onFieldSubmitted: _getPackage,
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}