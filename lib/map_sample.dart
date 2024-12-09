import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'utils.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(38.097418, 127.072470),
    zoom: 19.5,
  );

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  double _rotationAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() {
    _addMarker();
    _addVerticalLines();
  }

  Future<void> _addMarker() async {
    final BitmapDescriptor markerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/marker.png',
    );

    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('centerMarker'),
          position: _initialCameraPosition.target,
          icon: markerIcon,
        ),
      );
    });
  }

  void _addVerticalLines() {
    const double gap = 0.0001;
    final double startLat = _initialCameraPosition.target.latitude - 0.01;
    final double endLat = _initialCameraPosition.target.latitude + 0.01;
    final double centerLng = _initialCameraPosition.target.longitude;

    setState(() {
      _polylines.addAll(
        List.generate(5, (index) {
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
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onScaleUpdate: (details) {
          setState(() {
            _rotationAngle = details.rotation;
            _updatePolylines();
          });
        },
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.satellite,
              initialCameraPosition: _initialCameraPosition,
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationButtonEnabled: false,
            ),
            Positioned(
              bottom: 50,
              right: 10,
              child: FloatingActionButton(
                onPressed: _addAMarker,
                child: const Text('A'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addAMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('AMarker'),
          position: _initialCameraPosition.target,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    });
  }

  void _updatePolylines() {
    const double gap = 0.0001;
    final double centerLat = _initialCameraPosition.target.latitude;
    final double centerLng = _initialCameraPosition.target.longitude;

    _polylines.clear();
    _polylines.addAll(
      List.generate(5, (index) {
        int i = index - 2;
        final double offsetLng = i * gap;

        final LatLng start = rotatePoint(
          LatLng(centerLat - 0.01, centerLng + offsetLng),
          LatLng(centerLat, centerLng),
          _rotationAngle,
        );

        final LatLng end = rotatePoint(
          LatLng(centerLat + 0.01, centerLng + offsetLng),
          LatLng(centerLat, centerLng),
          _rotationAngle,
        );

        return Polyline(
          polylineId: PolylineId('line_$i'),
          color: i == 0 ? Colors.red : Colors.white,
          width: 2,
          points: [start, end],
        );
      }),
    );
  }
}
