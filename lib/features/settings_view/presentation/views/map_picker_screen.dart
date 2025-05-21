import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartsystemforschools/core/widgets/build_loading_view.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../../core/utils/app_styles.dart';

class MapPickerScreen extends StatefulWidget {
  final Function(String) onLocationSelected;

  const MapPickerScreen({
    super.key,
    required this.onLocationSelected,
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late Completer<GoogleMapController> _mapController;
  LatLng? _selectedLocation;
  String _address = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      _selectedLocation = LatLng(position.latitude, position.longitude);
      _getAddressFromLatLng(_selectedLocation!);

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _address =
            '${place.street}, ${place.administrativeArea} , ${place.country} , ${place.locality}';
        setState(() {});
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          'Select Location',
          style: AppStyles.styleBold20().copyWith(color: Colors.white),
        ),
        backgroundColor: const Color(0xff1A0F91),
      ),
      body: Stack(
        children: [
          if (_selectedLocation != null)
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _selectedLocation!,
                zoom: 15,
              ),
              onMapCreated: (controller) {
                _mapController.complete(controller);
                _getAddressFromLatLng(_selectedLocation!);
              },
              onTap: (LatLng position) {
                setState(() => _selectedLocation = position);
                _getAddressFromLatLng(position);
                _showBottomSheet();
              },
              markers: _selectedLocation == null
                  ? {}
                  : {
                      Marker(
                        markerId: const MarkerId('selected'),
                        position: _selectedLocation!,
                      ),
                    },
            )
          else if (_isLoading)
            Center(
              child: buildLoadingView(
                'map',
                context,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showBottomSheet() async {
    return await showModalBottomSheet(
      context: context,
      builder: (context) => BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, state) {
          final themeMode = context.watch<ThemeModeCubit>().currentTheme;
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: themeMode == ThemeMode.dark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      // Drag indicator
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: themeMode == ThemeMode.dark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Address text field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          enabled: false,
                          controller: TextEditingController(text: _address),
                          maxLines: 2,
                          style: AppStyles.styleRegular14(),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: themeMode == ThemeMode.dark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            hintText: 'Selected location address',
                            hintStyle: AppStyles.styleRegular14().copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Save button
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: _address.isNotEmpty
                              ? () {
                                  widget.onLocationSelected(_address);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeMode == ThemeMode.dark
                                ? Colors.grey.withOpacity(0.5)
                                : Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(
                            'Save Location',
                            style: AppStyles.styleMedium16().copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
