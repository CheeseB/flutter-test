import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
