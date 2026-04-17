import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jibon_Bachan_app/core/constants/app_text_styles.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/constants/app_colors.dart';

class FullMapScreen extends StatefulWidget {
  final LatLng initialLocation;
  const FullMapScreen({super.key, required this.initialLocation});

  @override
  State<FullMapScreen> createState() => _FullMapScreenState();
}

class _FullMapScreenState extends State<FullMapScreen> {
  late LatLng _pickedLocation;
  String _address = "Fetching address...";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation;
    _getAddress(_pickedLocation);
  }

  Future<void> _getAddress(LatLng point) async {
    setState(() => _isLoading = true);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        List<String?> parts = [
          place.name,
          place.subLocality,
          place.locality,
          place.administrativeArea,
        ];

        setState(() {
          _address = parts
              .where((part) => part != null && part.isNotEmpty)
              .toSet()
              .join(", ");
        });
      }
    } catch (e) {
      setState(() => _address = "Location Selected");
    }
    setState(() => _isLoading = false);
  }

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
          onPressed: () => Navigator.pop(context, _pickedLocation),
        ),
        title: Text("Select Location", style: AppTextStyles.navTitle),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _pickedLocation,
              initialZoom: 15.0,
              onTap: (tapPosition, point) {
                setState(() => _pickedLocation = point);
                _getAddress(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _pickedLocation,
                    width: 60,
                    height: 60,
                    child: const Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 45,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            bottom: 20,
            left: 15,
            right: 15,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.place, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _isLoading ? "Loading..." : _address,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, {
                            "location": _pickedLocation,
                            "address": _address,
                          });
                        },
                        child: Text(
                          "Confirm Location",
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
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
