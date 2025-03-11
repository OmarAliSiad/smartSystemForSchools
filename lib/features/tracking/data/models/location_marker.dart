// import 'package:latlong2/latlong.dart';

// class LocationMarker {
//   final String address;
//   final LatLng coordinates;
//   final double radius;

//   LocationMarker({
//     required this.address,
//     required this.coordinates,
//     this.radius = 0,
//   });

//   Map<String, dynamic> toJson() => {
//         'address': address,
//         'lat': coordinates.latitude,
//         'lng': coordinates.longitude,
//         'radius': radius,
//       };

//   factory LocationMarker.fromJson(Map<String, dynamic> json) {
//     return LocationMarker(
//       address: json['address'],
//       coordinates: LatLng(json['lat'], json['lng']),
//       radius: json['radius'] ?? 0,
//     );
//   }

//   bool containsPoint(LatLng point) {
//     if (radius <= 0) return false;

//     final distance = const Distance().as(
//       LengthUnit.Kilometer,
//       coordinates,
//       point,
//     );

//     return distance <= radius;
//   }
// }
