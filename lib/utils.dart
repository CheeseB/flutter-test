import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

LatLng rotatePoint(LatLng point, LatLng center, double angle) {
  final double cosAngle = cos(angle);
  final double sinAngle = sin(angle);

  final double translatedLat = point.latitude - center.latitude;
  final double translatedLng = point.longitude - center.longitude;

  final double rotatedLat = translatedLat * cosAngle - translatedLng * sinAngle;
  final double rotatedLng = translatedLat * sinAngle + translatedLng * cosAngle;

  return LatLng(
    rotatedLat + center.latitude,
    rotatedLng + center.longitude,
  );
}
