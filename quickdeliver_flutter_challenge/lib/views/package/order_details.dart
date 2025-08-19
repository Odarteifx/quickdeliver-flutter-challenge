import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../../core/app_colors.dart';
import '../../core/app_fonts.dart';
import '../../widgets/home_widgets/status_badge.dart';
import '../../widgets/package_widgets/progress_stepper.dart';

class OrderDetailsScreen extends StatefulWidget {
  final DocumentSnapshot order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _setupMap();
     _getRoute();
  }

  void _setupMap() {
    // Example: get LatLng from Firestore
    double pickupLat = widget.order['pickupLat'];
    double pickupLng = widget.order['pickupLng'];
    double dropOffLat = widget.order['dropOffLat'];
    double dropOffLng = widget.order['dropOffLng'];

    final pickup = LatLng(pickupLat, pickupLng);
    final dropOff = LatLng(dropOffLat, dropOffLng);

    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickup,
          infoWindow: const InfoWindow(title: 'Pickup'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );

      _markers.add(
        Marker(
          markerId: const MarkerId('dropOff'),
          position: dropOff,
          infoWindow: const InfoWindow(title: 'Drop-off'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );

      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [pickup, dropOff],
          color: Colors.black,
          width: 4,
        ),
      );
    });
  }

  void _getRoute() async {
  double pickupLat = widget.order['pickupLat'];
  double pickupLng = widget.order['pickupLng'];
  double dropOffLat = widget.order['dropOffLat'];
  double dropOffLng = widget.order['dropOffLng'];

  PolylinePoints polylinePoints = PolylinePoints(apiKey: 'AIzaSyAkLJl0_qRbYcIU4h0OWzdF8DzxXm8djaY');

  // ✅ New way using PolylineRequest
  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    request: PolylineRequest(
      origin: PointLatLng(pickupLat, pickupLng),
      destination: PointLatLng(dropOffLat, dropOffLng),
      mode: TravelMode.driving, // walking, bicycling also available

    ),
  );

  if (result.points.isNotEmpty) {
    polylineCoordinates.clear();
    for (var point in result.points) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    }

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId("route"),
          points: polylineCoordinates,
          color: AppColors.primary,
          width: 5,
        ),
      );
    });
  } else {
    debugPrint("No polyline points found: ${result.errorMessage}");
  }
}



  @override
  Widget build(BuildContext context) {
    final String orderID = widget.order['orderID'];
    final String pickup = widget.order['pickupLocation'];
    final String dropOff = widget.order['dropOffLocation'];
    final String receiverName = widget.order['receiverName'];
    final String receiverPhone = widget.order['receiverPhone'];
    final String description = widget.order['description'];
    final String size = widget.order['size'];
    final String instructions = widget.order['instructions'] ?? '';
    final String status = widget.order['status'];

    final LatLng initialPosition = LatLng(
      widget.order['pickupLat'],
      widget.order['pickupLng'],
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Order Details',
          style: GoogleFonts.poppins(
            fontWeight: AppFontweight.semibold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 12,
              ),
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order ID: $orderID',
                          style: GoogleFonts.poppins(
                            fontWeight: AppFontweight.semibold,
                            fontSize: AppFonts.subtext,
                          ),
                        ),
                        StatusBadge(status: status),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    OrderProgressStepper(status: status),
                    SizedBox(height: 20.h),
                    Column(
                      spacing: 7.h,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Receiver:',
                              style: GoogleFonts.poppins(
                                  fontSize: AppFonts.subtext,
                                  fontWeight: AppFontweight.medium),
                            ),
                            Text(
                              receiverName,
                              style: GoogleFonts.poppins(
                                  fontWeight: AppFontweight.medium),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pick Up:',
                              style: GoogleFonts.poppins(
                                  fontSize: AppFonts.subtext,
                                  fontWeight: AppFontweight.medium),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Expanded(
                              child: Text(
                                pickup,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.right,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Drop Up:',
                              style: GoogleFonts.poppins(
                                  fontSize: AppFonts.subtext,
                                  fontWeight: AppFontweight.medium),
                            ),
                            Expanded(
                              child: Text(
                                dropOff,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.right,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Contact:',
                              style: GoogleFonts.poppins(
                                  fontSize: AppFonts.subtext,
                                  fontWeight: AppFontweight.medium),
                            ),
                            Text(receiverPhone)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Description:',
                              style: GoogleFonts.poppins(
                                  fontSize: AppFonts.subtext,
                                  fontWeight: AppFontweight.medium),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Expanded(
                                child: Text(
                              description,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Size:',
                              style: GoogleFonts.poppins(
                                  fontSize: AppFonts.subtext,
                                  fontWeight: AppFontweight.medium),
                            ),
                            Text(
                              size,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Instructions:',
                              style: GoogleFonts.poppins(
                                  fontSize: AppFonts.subtext,
                                  fontWeight: AppFontweight.medium),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Expanded(
                              child: Text(
                                instructions.isNotEmpty ? instructions : '--',
                                style: GoogleFonts.poppins(
                                    color: instructions.isNotEmpty
                                        ? null
                                        : AppColors.iconColor),
                                textAlign: TextAlign.right,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
