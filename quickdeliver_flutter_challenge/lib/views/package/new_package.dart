import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_colors.dart';
import '../../core/app_fonts.dart';
import '../../services/order_service.dart';
import '../../widgets/auth_widgets/action_btn.dart';

class NewDelivery extends StatefulWidget {
  const NewDelivery({super.key});

  @override
  State<NewDelivery> createState() => _NewDeliveryState();
}

class _NewDeliveryState extends State<NewDelivery> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropOffController = TextEditingController();
  final TextEditingController _receiverNameController = TextEditingController();
  final TextEditingController _receiverPhoneController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();

  final _orderService = OrderService();

  Future<void> submitOrder() async {
    if (_formkey.currentState!.validate()) {
      try {
        await _orderService.createOrder(
          pickupLocation: _pickupController.text.trim(),
          dropOffLocation: _dropOffController.text.trim(),
          receiverName: _receiverNameController.text.trim(),
          receiverPhone: _receiverPhoneController.text.trim(),
          description: _descriptionController.text.trim(),
          instructions: _instructionsController.text.trim(), 
          size: _sizeController.text.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order Placed Successfully!')),
          );
          context.pop();
        }

        // Go back to Home
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text("New Delivery"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.sp),
          child: Form(
            key: _formkey,
            child: Column(
              spacing: 10.sp,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _pickupController,
                  style: TextStyle(fontSize: AppFonts.subtext),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      hintText: 'Pickup Location',
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
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter pickup location';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _dropOffController,
                  style: TextStyle(fontSize: AppFonts.subtext),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      hintText: 'Drop-off Location',
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
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter drop-off location';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _receiverNameController,
                  style: TextStyle(fontSize: AppFonts.subtext),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      hintText: 'Receiver Name',
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
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter recipient\'s name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter receiver phone number";
                    }
                    if (value.length < 10) {
                      return "Enter a valid phone number";
                    }
                    return null;
                  },
                  controller: _receiverPhoneController,
                  keyboardType: TextInputType.phone,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: GoogleFonts.poppins(fontSize: AppFonts.subtext),
                  decoration: InputDecoration(
                      hintText: 'Receiver Phone',
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
                      )),
                ),
                TextFormField(
                  controller: _sizeController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextStyle(fontSize: AppFonts.subtext),
                  decoration: InputDecoration(
                      hintText: 'Package Description',
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
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter package description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextStyle(fontSize: AppFonts.subtext),
                  decoration: InputDecoration(
                      hintText: 'Package Size',
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
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter package size';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _instructionsController,
                  style: GoogleFonts.poppins(fontSize: AppFonts.subtext),
                  maxLines: 3,
                  decoration: InputDecoration(
                      hintText: 'Special Instructions',
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
                      )),
                ),
                SizedBox(height: 10.h),
                MajorButton(
                  buttonText: 'Place Order',
                  function: () {
                    submitOrder();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
