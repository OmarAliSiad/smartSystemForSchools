// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:smartsystemforschools/core/utils/app_styles.dart';
// import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';
// import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
// import 'package:smartsystemforschools/features/settings_view/presentation/widgets/custom_text_field_edit_profile_widget.dart';
// import '../../data/models/location_marker.dart';
// import 'package:http/http.dart' as http;
// import '../../data/models/student_location.dart';
// import 'dart:async';

// class TrackingView extends StatefulWidget {
//   final Function(LocationMarker) onLocationSelected;
//   final List<LocationMarker> initialLocations;
//   final List<String> studentIds;

//   const TrackingView({
//     super.key,
//     required this.onLocationSelected,
//     this.initialLocations = const [],
//     this.studentIds = const [],
//   });

//   @override
//   State<TrackingView> createState() => _TrackingViewState();
// }

// class _TrackingViewState extends State<TrackingView> {
//   static const String apiEndpoint = 'https://nominatim.openstreetmap.org';
//   LatLng? center;
//   double currentRadius = 1000;
//   final mapController = MapController();
//   static const double minRadius = 100;
//   static const double maxRadius = 10000;
//   List<LocationMarker> locations = [];
//   LocationMarker? selectedLocation;
//   final searchController = TextEditingController();
//   List<dynamic> searchResults = [];
//   bool isSearching = false;
//   List<StudentLocation> studentLocations = [];
//   Timer? _locationUpdateTimer;

//   @override
//   void initState() {
//     super.initState();
//     locations = List.from(widget.initialLocations);
//     if (locations.isNotEmpty) {
//       // mapController.move(locations.first.coordinates, 13);
//     }
//     _startLocationUpdates();
//   }

//   @override
//   void dispose() {
//     _locationUpdateTimer?.cancel();
//     searchController.dispose();
//     super.dispose();
//   }

//   void _startLocationUpdates() {
//     _locationUpdateTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
//       _updateStudentLocations();
//     });
//     _updateStudentLocations();
//   }

//   Future<void> _updateStudentLocations() async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//             '$apiEndpoint/student-locations?ids=${widget.studentIds.join(",")}'),
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         setState(() {
//           studentLocations =
//               data.map((json) => StudentLocation.fromJson(json)).toList();
//           for (var i = 0; i < studentLocations.length; i++) {
//             final student = studentLocations[i];
//             bool isInside = false;
//             for (var location in locations) {
//               if (location.containsPoint(student.location)) {
//                 isInside = true;
//                 break;
//               }
//             }
//             if (isInside != student.isInsideGeofence) {
//               _handleGeofenceTransition(student, isInside);
//             }
//           }
//         });
//       }
//     } catch (e) {
//       print('Error updating student locations: $e');
//     }
//   }

//   void _handleGeofenceTransition(StudentLocation student, bool isInside) {
//     final action = isInside ? 'entered' : 'left';
//     final message = '${student.studentName} has $action the designated area';
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   Future<void> _searchLocation(String query) async {
//     if (query.isEmpty) {
//       setState(() {
//         searchResults = [];
//         isSearching = false;
//       });
//       return;
//     }

//     setState(() {
//       isSearching = true;
//     });

//     try {
//       final response = await http.get(
//         Uri.parse(
//           'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=5',
//         ),
//       );

//       if (response.statusCode == 200) {
//         final results = json.decode(response.body);
//         setState(() {
//           searchResults = results;
//           isSearching = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         searchResults = [];
//         isSearching = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error searching location: $e')),
//       );
//     }
//   }

//   void _selectSearchResult(dynamic result) {
//     final lat = double.parse(result['lat']);
//     final lon = double.parse(result['lon']);
//     final newCenter = LatLng(lat, lon);

//     setState(() {
//       center = newCenter;
//       searchResults = [];
//       searchController.clear();
//     });

//     mapController.move(newCenter, 15);
//   }

//   void _handleTap(TapPosition tapPosition, LatLng point) async {
//     setState(() {
//       center = point;
//       selectedLocation = null;
//     });
//   }

//   void _confirmSelection() async {
//     if (center != null) {
//       try {
//         final response = await http.get(
//           Uri.parse(
//             'https://nominatim.openstreetmap.org/reverse?lat=${center!.latitude}&lon=${center!.longitude}&format=json',
//           ),
//         );

//         if (response.statusCode == 200) {
//           final data = json.decode(response.body);
//           final address = data['display_name'] as String;

//           final marker = LocationMarker(
//             address: address,
//             coordinates: center!,
//             radius: currentRadius,
//           );

//           setState(() {
//             locations.add(marker);
//             center = null;
//             currentRadius = 1000;
//             selectedLocation = null;
//           });

//           widget.onLocationSelected(marker);
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error getting location: $e')),
//         );
//       }
//     }
//   }

//   void _editLocation(LocationMarker location) {
//     setState(() {
//       selectedLocation = location;
//       center = location.coordinates;
//       currentRadius = location.radius;
//     });
//   }

//   void _updateLocation() async {
//     if (selectedLocation != null && center != null) {
//       try {
//         final response = await http.get(
//           Uri.parse(
//             'https://nominatim.openstreetmap.org/reverse?lat=${center!.latitude}&lon=${center!.longitude}&format=json',
//           ),
//         );

//         if (response.statusCode == 200) {
//           final data = json.decode(response.body);
//           final address = data['display_name'] as String;

//           final updatedMarker = LocationMarker(
//             address: address,
//             coordinates: center!,
//             radius: currentRadius,
//           );

//           setState(() {
//             final index = locations.indexOf(selectedLocation!);
//             if (index != -1) {
//               locations[index] = updatedMarker;
//             }
//             center = null;
//             currentRadius = 1000;
//             selectedLocation = null;
//           });

//           widget.onLocationSelected(updatedMarker);
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error updating location: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               child: Padding(
//                 padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
//                 child: TextField(
//                   cursorColor: context.read<ThemeModeCubit>().currentTheme ==
//                           ThemeMode.dark
//                       ? Colors.white
//                       : Colors.black,
//                   controller: searchController,
//                   decoration: InputDecoration(
//                     hintText: 'Search location...',
//                     prefixIcon: const Icon(Icons.search),
//                     suffixIcon: searchController.text.isNotEmpty
//                         ? IconButton(
//                             icon: const Icon(Icons.clear),
//                             onPressed: () {
//                               searchController.clear();
//                               setState(() {
//                                 searchResults = [];
//                               });
//                             },
//                           )
//                         : null,
//                     border: buildOutlineBorder(borderRadius: 8),
//                     focusedBorder: buildOutlineBorder(borderRadius: 8),
//                   ),
//                   onChanged: (value) {
//                     if (value.length >= 3) {
//                       _searchLocation(value);
//                     } else {
//                       setState(() {
//                         searchResults = [];
//                       });
//                     }
//                   },
//                 ),
//               ),
//             ),
//             if (searchResults.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
//                 child: Container(
//                   constraints: BoxConstraints(
//                     maxHeight: MediaQuery.of(context).size.height * 0.4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: context.read<ThemeModeCubit>().currentTheme ==
//                             ThemeMode.dark
//                         ? Colors.black
//                         : Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                     boxShadow: [
//                       BoxShadow(
//                         color: context.read<ThemeModeCubit>().currentTheme ==
//                                 ThemeMode.dark
//                             ? const Color(0xFFFFFFFF).withOpacity(.4)
//                             : const Color(0x3F000000),
//                         blurRadius: 6,
//                         offset: const Offset(0, 0),
//                         spreadRadius: 0,
//                       )
//                     ],
//                   ),
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     physics: const BouncingScrollPhysics(),
//                     itemCount: searchResults.length,
//                     itemBuilder: (context, index) {
//                       final result = searchResults[index];
//                       return ListTile(
//                         trailing: const Icon(Icons.location_on),
//                         title: Text(
//                           result['display_name'],
//                           style: AppStyles.styleMedium16(),
//                         ),
//                         onTap: () => _selectSearchResult(result),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             if (isSearching)
//               const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: CircularProgressIndicator(),
//               ),
//             Padding(
//               padding: const EdgeInsetsDirectional.symmetric(
//                   vertical: 8, horizontal: 16),
//               child: Text(
//                 center == null
//                     ? 'Tap to set a new region or click existing markers to edit'
//                     : 'Use the slider to adjust the radius',
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyMedium!
//                     .copyWith(fontSize: 13),
//               ),
//             ),
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Stack(
//                   children: [
//                     FlutterMap(
//                       mapController: mapController,
//                       options: MapOptions(
//                         initialCenter: widget.initialLocations.isNotEmpty
//                             ? widget.initialLocations.first.coordinates
//                             : const LatLng(37.7749, -122.4194),
//                         initialZoom: 13,
//                         onTap: _handleTap,
//                       ),
//                       children: [
//                         TileLayer(
//                           urlTemplate:
//                               'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                           subdomains: const ['a', 'b', 'c'],
//                         ),
//                         MarkerLayer(
//                           markers: [
//                             for (var location in locations)
//                               Marker(
//                                 point: location.coordinates,
//                                 width: 30,
//                                 height: 30,
//                                 child: GestureDetector(
//                                   onTap: () => _editLocation(location),
//                                   child: Icon(
//                                     Icons.location_on,
//                                     color: selectedLocation == location
//                                         ? Colors.green
//                                         : Colors.red,
//                                     size: 30,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                         MarkerLayer(
//                           markers: [
//                             for (var student in studentLocations)
//                               Marker(
//                                 point: student.location,
//                                 width: 40,
//                                 height: 40,
//                                 child: Tooltip(
//                                   message:
//                                       '${student.studentName}\n${student.isInsideGeofence ? 'Inside zone' : 'Outside zone'}',
//                                   child: Icon(
//                                     Icons.person_pin_circle,
//                                     color: student.isInsideGeofence
//                                         ? Colors.green
//                                         : Colors.red,
//                                     size: 40,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                         CircleLayer(
//                           circles: [
//                             for (var location in locations)
//                               CircleMarker(
//                                 point: location.coordinates,
//                                 radius: location.radius,
//                                 useRadiusInMeter: true,
//                                 color: selectedLocation == location
//                                     ? Colors.green.withOpacity(0.2)
//                                     : Colors.blue.withOpacity(0.2),
//                                 borderColor: selectedLocation == location
//                                     ? Colors.green
//                                     : Colors.blue,
//                                 borderStrokeWidth: 2,
//                               ),
//                           ],
//                         ),
//                         if (center != null && selectedLocation == null) ...[
//                           MarkerLayer(
//                             markers: [
//                               Marker(
//                                 point: center!,
//                                 width: 30,
//                                 height: 30,
//                                 child: const Icon(
//                                   Icons.location_on,
//                                   color: Colors.orange,
//                                   size: 30,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           CircleLayer(
//                             circles: [
//                               CircleMarker(
//                                 point: center!,
//                                 radius: currentRadius,
//                                 useRadiusInMeter: true,
//                                 color: Colors.orange.withOpacity(0.2),
//                                 borderColor: Colors.orange,
//                                 borderStrokeWidth: 2,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ],
//                     ),
//                     Positioned(
//                       right: 0,
//                       bottom: 0,
//                       child: Column(
//                         children: [
//                           FloatingActionButton(
//                             heroTag: "zoom_in",
//                             mini: true,
//                             backgroundColor: Colors.white,
//                             onPressed: () {
//                               final zoom = mapController.camera.zoom + 1;
//                               mapController.move(
//                                   mapController.camera.center, zoom);
//                             },
//                             child: const Icon(
//                               Icons.add,
//                               color: Colors.black,
//                             ),
//                           ),
//                           FloatingActionButton(
//                             heroTag: "zoom_out",
//                             mini: true,
//                             backgroundColor: Colors.white,
//                             onPressed: () {
//                               final zoom = mapController.camera.zoom - 1;
//                               mapController.move(
//                                   mapController.camera.center, zoom);
//                             },
//                             child: const Icon(
//                               Icons.remove,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     if (center != null)
//                       Positioned(
//                         left: 16,
//                         right: 16,
//                         bottom: 16,
//                         child: Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const Text('100m'),
//                                   Text(
//                                     'Radius: ${(currentRadius / 1000).toStringAsFixed(1)}km',
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   const Text('10km'),
//                                 ],
//                               ),
//                               SliderTheme(
//                                 data: SliderTheme.of(context).copyWith(
//                                   activeTrackColor: Colors.blue,
//                                   inactiveTrackColor:
//                                       Colors.blue.withOpacity(0.2),
//                                   thumbColor: Colors.blue,
//                                   overlayColor: Colors.blue.withOpacity(0.1),
//                                 ),
//                                 child: Slider(
//                                   value: currentRadius,
//                                   min: minRadius,
//                                   max: maxRadius,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       currentRadius = value;
//                                     });
//                                   },
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           center = null;
//                                           currentRadius = 1000;
//                                           selectedLocation = null;
//                                         });
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.red,
//                                         foregroundColor: Colors.white,
//                                       ),
//                                       child: const Text('Cancel'),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Expanded(
//                                     child: ElevatedButton(
//                                       onPressed: selectedLocation != null
//                                           ? _updateLocation
//                                           : _confirmSelection,
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.green,
//                                         foregroundColor: Colors.white,
//                                       ),
//                                       child: Text(selectedLocation != null
//                                           ? 'Update'
//                                           : 'Add'),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
