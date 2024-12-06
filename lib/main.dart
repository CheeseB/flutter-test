import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application.

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapSample()),
                );
              },
              child: const Text('Map'),
            ),
          ],
        ),
      ),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(38.097418, 127.072470),
    zoom: 19.5,
  );

  // Add a marker
  final Set<Marker> _markers = {};

  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
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
          position: _kGooglePlex.target,
          icon: markerIcon,
        ),
      );
    });
  }

  void _addVerticalLines() {
    const double gap = 0.0001; // Keep the gap tight
    final double startLat =
        _kGooglePlex.target.latitude - 0.01; // Extend the start latitude
    final double endLat =
        _kGooglePlex.target.latitude + 0.01; // Extend the end latitude
    final double centerLng = _kGooglePlex.target.longitude;

    setState(() {
      _polylines.addAll(
        List.generate(5, (index) {
          int i = index - 2; // Adjust index to range from -2 to 2
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
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.satellite,
            initialCameraPosition: _kGooglePlex,
            markers: _markers,
            polylines: _polylines, // Add polylines to the map
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
    );
  }

  void _addAMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('AMarker'),
          position: _kGooglePlex.target,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    });
  }
}
