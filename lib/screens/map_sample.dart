import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_flutter/utils/map.dart';
import 'package:my_flutter/providers/custom_tile_provider.dart';
import 'package:my_flutter/constants/index.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildGoogleMap(),
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
