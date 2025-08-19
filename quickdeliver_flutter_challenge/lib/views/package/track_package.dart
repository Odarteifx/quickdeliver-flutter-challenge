import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:quickdeliver_flutter_challenge/core/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeliver_flutter_challenge/widgets/home_widgets/status_badge.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/app_fonts.dart';

class TrackPackage extends StatefulWidget {
  const TrackPackage({super.key});

  @override
  State<TrackPackage> createState() => _TrackPackageState();
}

class _TrackPackageState extends State<TrackPackage> {
  final TextEditingController _trackingController = TextEditingController();
  bool _isLoading = false;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _suggestions = [];
  bool _isSuggesting = false;

  Future<void> _getPackage(String input) async {
    final String query = input.trim();
    if (query.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a package number')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      print('Searching for orderID: $query');
      print('User ID: ${user.uid}');
      
      // First get all user's orders
      final snapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .where('userId', isEqualTo: user.uid)
          .get();

      print('Found ${snapshot.docs.length} total documents for user');
      
      // Filter client-side for exact match
      final matchingDocs = snapshot.docs.where((doc) {
        final orderId = doc.data()['orderID'] as String? ?? '';
        return orderId.toLowerCase() == query.toLowerCase();
      }).toList();
      
      print('Found ${matchingDocs.length} matching documents');

      if (!mounted) return;

      if (matchingDocs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Package not found')),
        );
      } else {
        final doc = matchingDocs.first;
        context.push('/orderDetails', extra: doc);
      }
    } catch (e) {
      print('Error searching: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }

  }

  Future<void> _fetchSuggestions(String input) async {
    final String query = input.trim();
    if (query.length < 2) {
      setState(() {
        _suggestions = [];
      });
      return;
    }
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    setState(() => _isSuggesting = true);
    try {
      final results = await FirebaseFirestore.instance
          .collection('Orders')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();
      
      if (!mounted) return;
      
      // Filter client-side for orderID prefix match
      final filteredDocs = results.docs.where((doc) {
        final orderId = doc.data()['orderID'] as String? ?? '';
        return orderId.toLowerCase().startsWith(query.toLowerCase());
      }).take(10).toList();
      
      setState(() {
        _suggestions = filteredDocs;
      });
    } catch (_) {
      // ignore
    } finally {
      if (mounted) setState(() => _isSuggesting = false);
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
              SizedBox(
                height: 10.h,
              ),
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
                  suffixIcon: (_isLoading || _isSuggesting)
                      ? Padding(
                          padding: EdgeInsets.all(15.sp),
                          child: SizedBox(
                            width: 10.sp,
                            height:10.sp,
                            child:
                                const CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: Icon(Iconsax.search_normal_copy, color: AppColors.subtext, size: 22.sp, ),
                          onPressed: () =>
                              _getPackage(_trackingController.text),
                        ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Invalid Package Number';
                  }
                  return null;
                },
                onChanged: _fetchSuggestions,
                onFieldSubmitted: _getPackage,
              ),
              if (_suggestions.isNotEmpty) ...[
                SizedBox(height: 10.h),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final doc = _suggestions[index];
                    final data = doc.data();
                    final orderId = data['orderID'] as String? ?? '';
                    final status = data['status'] as String? ?? '';
                    return Card(
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          _trackingController.text = orderId;
                          setState(() => _suggestions = []);
                          context.push('/orderDetails', extra: doc);
                        },
                        child: Container(
                          decoration:
                              BoxDecoration(color: AppColors.background,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(width: 0.5.sp, color: AppColors.iconColor)),
                          child: Padding(
                            padding: EdgeInsets.all(20.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(orderId,
                                    style: GoogleFonts.poppins(
                                        fontSize: AppFonts.subtext, fontWeight: AppFontweight.semibold, color: AppColors.subtext)),
                                StatusBadge(status: status)
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
