import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickdeliver_flutter_challenge/widgets/home_widgets/deliveries_list.dart';

import '../../core/app_colors.dart';
import '../../core/app_fonts.dart';
import '../../widgets/home_widgets/status_badge.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  final user = FirebaseAuth.instance.currentUser;
  String selectedStatus = 'All';

  final List<String> statuses = [
    'All',
    'Placed',
    'Picked Up',
    'In Transit',
    'Delivered'
  ];

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(child: Text('You must be logged in.'));
    }

    Query ordersQuery = FirebaseFirestore.instance
        .collection('Orders')
        .where('userId', isEqualTo: user!.uid);

    if (selectedStatus != 'All') {
      ordersQuery = ordersQuery.where('status', isEqualTo: selectedStatus);
    }

    ordersQuery = ordersQuery.orderBy('createdAt', descending: true);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'My Packages',
          style: GoogleFonts.poppins(fontWeight: AppFontweight.semibold),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),

          // Status filter bar
          SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              itemCount: statuses.length,
              itemBuilder: (context, index) {
                final status = statuses[index];
                final isSelected = status == selectedStatus;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: ChoiceChip(
                    label: Text(status),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: GoogleFonts.poppins(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: AppFontweight.medium,
                    ),
                    onSelected: (_) {
                      setState(() {
                        selectedStatus = status;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 10.h),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ordersQuery.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No packages found.',
                      style: GoogleFonts.poppins(
                        fontSize: AppFonts.subtext,
                        fontWeight: AppFontweight.medium,
                        color: AppColors.iconColor,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final order = docs[index];
                    final orderID = order['orderID'];
                    final dropOff = order['dropOffLocation'];
                    final status = order['status'];
                    final receiver = order['receiverName'];
                      final contact = order['receiverPhone'];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: OrderTile(
                          doc: order,
                          orderID: orderID,
                          status: status,
                          dropOff: dropOff,
                          receiver: receiver,
                          contact: contact),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
