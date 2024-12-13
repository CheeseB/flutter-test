import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

Future<BitmapDescriptor> loadMarkerIcon(String assetPath, Size size) async {
  return await BitmapDescriptor.asset(
    ImageConfiguration(size: size),
    assetPath,
  );
}

Marker createMarker(LatLng position, BitmapDescriptor icon, String markerId) {
  return Marker(
    markerId: MarkerId(markerId),
    position: position,
    icon: icon,
  );
}

List<Polyline> createVerticalLines(LatLng center) {
  const double gap = 0.0001;
  final double startLat = center.latitude - 0.01;
  final double endLat = center.latitude + 0.01;
  final double centerLng = center.longitude;

  return List.generate(5, (index) {
    int i = index - 2;
    return Polyline(
      polylineId: PolylineId('line_$i'),
      color: i == 0 ? Colors.red : Colors.white,
      width: 2,
      points: [
        LatLng(startLat, centerLng + i * gap),
        LatLng(endLat, centerLng + i * gap),
      ],
    );
  });
}

bool isWithinKorea(CameraPosition position) {
  return position.target.latitude >= 33.0 &&
      position.target.latitude <= 43.0 &&
      position.target.longitude >= 124.0 &&
      position.target.longitude <= 132.0;
}

Set<TileOverlay> getTileOverlays(
    CameraPosition position, TileProvider provider) {
  if (isWithinKorea(position) && position.zoom >= 17) {
    return {
      TileOverlay(
        tileOverlayId: const TileOverlayId('sampleId'),
        tileProvider: provider,
        zIndex: -1,
      ),
    };
  } else {
    return {};
  }
}

List<Polyline> createRotatedLines(LatLng center, double angle) {
  const double gap = 0.0001;
  final double startLat = center.latitude - 0.01;
  final double endLat = center.latitude + 0.01;
  final double centerLng = center.longitude;

  return List.generate(5, (index) {
    int i = index - 2;
    return Polyline(
      polylineId: PolylineId('line_$i'),
      color: i == 0 ? Colors.red : Colors.white,
      width: 2,
      points: [
        rotatePoint(LatLng(startLat, centerLng + i * gap), center, angle),
        rotatePoint(LatLng(endLat, centerLng + i * gap), center, angle),
      ],
    );
  });
}

LatLng rotatePoint(LatLng point, LatLng center, double angle) {
  double rad = angle * (pi / 180.0); // Convert to radians
  double cosTheta = cos(rad);
  double sinTheta = sin(rad);
  double dx = point.latitude - center.latitude;
  double dy = point.longitude - center.longitude;

  return LatLng(
    center.latitude + (dx * cosTheta - dy * sinTheta),
    center.longitude + (dx * sinTheta + dy * cosTheta),
  );
}
