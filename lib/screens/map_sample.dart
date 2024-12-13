import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/map.dart';
import '../providers/custom_tile_provider.dart';
import '../constants/icon.dart';
import '../constants/map.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(initialLatitude, initialLongitude),
    zoom: initialZoom,
  );

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final TileProvider _googleTileProvider = CustomTileProvider();
  CameraPosition _currentCameraPosition = _initialCameraPosition;
  double _currentAngle = 0.0; // Track the current rotation angle

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() {
    _addInitialMarker();
    _addVerticalLines();
  }

  Future<void> _addInitialMarker() async {
    final BitmapDescriptor markerIcon =
        await loadMarkerIcon(centerMarkerIcon, const Size(48, 48));
    _addMarker(_initialCameraPosition.target, markerIcon, 'centerMarker');
  }

  void _addMarker(LatLng position, BitmapDescriptor icon, String markerId) {
    setState(() {
      _markers.add(createMarker(position, icon, markerId));
    });
  }

  void _addVerticalLines() {
    setState(() {
      _polylines.addAll(createVerticalLines(_initialCameraPosition.target));
    });
  }

  void _rotateLines(double delta) {
    setState(() {
      _currentAngle -= delta * 0.1; // Subtract to follow the finger direction
      _polylines.clear();
      _polylines.addAll(
          createRotatedLines(_initialCameraPosition.target, _currentAngle));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              _rotateLines(details.delta.dx);
            },
            child: _buildGoogleMap(),
          ),
        ],
      ),
    );
  }

  GoogleMap _buildGoogleMap() {
    return GoogleMap(
      mapType: MapType.satellite,
      initialCameraPosition: _initialCameraPosition,
      markers: _markers,
      polylines: _polylines,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      myLocationButtonEnabled: false,
      onCameraMove: (CameraPosition position) {
        setState(() {
          _currentCameraPosition = position;
        });
      },
      tileOverlays: _getTileOverlays(),
    );
  }

  Set<TileOverlay> _getTileOverlays() {
    return getTileOverlays(_currentCameraPosition, _googleTileProvider);
  }
}
