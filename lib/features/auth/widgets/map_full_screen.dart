import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:jibon_Bachan_app/core/constants/app_text_styles.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/constants/app_colors.dart';

class FullMapScreen extends StatelessWidget {
  final LatLng initialLocation;
  const FullMapScreen({super.key, required this.initialLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Select Location", style: AppTextStyles.navTitle),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(initialCenter: initialLocation, initialZoom: 15.0),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.myproject.blood_donation_app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: initialLocation,
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
