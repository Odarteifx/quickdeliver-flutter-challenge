import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/app_fonts.dart';

class OrderProgressStepper extends StatelessWidget {
  final String status;

  const OrderProgressStepper({super.key, required this.status});

  int getCurrentStep() {
    switch (status) {
      case 'Placed':
        return 0;
      case 'Picked Up':
        return 1;
      case 'In Transit':
        return 2;
      case 'Delivered':
        return 3;
      default:
        return 0;
    }
  }

     Color? getTextColor() {
    switch (status) {
      case 'Placed':
        return Colors.amber[700];
      case 'Picked Up':
        return Colors.blue[700];
      case 'In Transit':
        return Colors.teal[700];
      case 'Delivered':
        return Colors.green[700];
      case 'Cancelled':
        return Colors.red[700]!;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int currentStep = getCurrentStep();
    final List<String> statuses = ['Placed', 'Picked Up', 'In Transit', 'Delivered'];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circles & lines row
        Row(
          children: List.generate(statuses.length * 2 - 1, (index) {
            if (index.isEven) {
              final int stepIndex = index ~/ 2;
              final bool isActive = currentStep >= stepIndex;

              return Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: isActive ? getTextColor() : Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: isActive
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Center(
                            child: Text(
                              '${stepIndex + 1}',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                  ),
                ),
              );
            } else {
              final int lineIndex = (index - 1) ~/ 2;
              final bool isActive = currentStep > lineIndex;

              return Expanded(
                child: Container(
                  height: 2,
                  color: isActive ? getTextColor() : Colors.grey[300],
                ),
              );
            }
          }),
        ),

        SizedBox(height: 8.h),

        // Status labels row
        Row(
          children: List.generate(statuses.length * 2 - 1, (index) {
            if (index.isEven) {
              final int labelIndex = index ~/ 2;
              final bool isActive = currentStep >= labelIndex;

              return Expanded(
                child: Text(
                  statuses[labelIndex],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: isActive ? AppFontweight.semibold : AppFontweight.regular,
                    color: isActive? getTextColor() : Colors.grey[300],
                  ),
                ),
              );
            } else {
              return Expanded(child: SizedBox());
            }
          }),
        ),
      ],
    );
  }
}

