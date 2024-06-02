import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolygoneScreen extends StatefulWidget {
  const PolygoneScreen({super.key});

  @override
  _PolygoneScreenState createState() => _PolygoneScreenState();
}

class _PolygoneScreenState extends State<PolygoneScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(21.705664, 70.575681),
    zoom: 14,
  );
  final Set<Marker> _markers = {};
  final Set<Polygon> _polygone = HashSet<Polygon>();

  List<LatLng> points = [
    const LatLng(21.705664, 70.575681),
    const LatLng(21.707246, 70.574337),
    const LatLng(21.709817, 70.572918),
    const LatLng(21.711462, 70.572516),
    const LatLng(21.711280, 70.573842),
    const LatLng(21.712307, 70.574629),
    const LatLng(21.710755, 70.576201),
    const LatLng(21.711211, 70.579322),
    const LatLng(21.713431, 70.581462),
    const LatLng(21.711880, 70.582637),
    const LatLng(21.712351, 70.584304),
    const LatLng(21.710478, 70.586338),
    const LatLng(21.710275, 70.585612),
    const LatLng(21.708939, 70.584182),
    const LatLng(21.707790, 70.583291),
    const LatLng(21.707790, 70.583291),
    const LatLng(21.707790, 70.583291),
    const LatLng(21.703270, 70.584292),
    const LatLng(21.701774, 70.581626),
    const LatLng(21.703235, 70.582375),
    const LatLng(21.705085, 70.581411),
    const LatLng(21.706119, 70.578510),
    const LatLng(21.705949, 70.576912),
    const LatLng(21.705664, 70.575681),
  ];

  void _setPolygone() {
    _polygone.add(
      Polygon(
        polygonId: const PolygonId('1'),
        points: points,
        strokeColor: Colors.deepOrange,
        strokeWidth: 2,
        fillColor: Colors.deepOrange.withOpacity(0.1),
        geodesic: true,
        consumeTapEvents: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _setPolygone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Polygone',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        myLocationButtonEnabled: true,
        myLocationEnabled: false,
        // cameraTargetBounds: CameraTargetBounds(LatLngBounds(
        //   northeast: LatLng(9.006808, -79.508148),
        //   southwest:  LatLng(9.003121, -79.505702),
        // )),
        //  onCameraMove: ((_position) => _updatePosition(_position)),
        markers: _markers,
        polygons: _polygone,

        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
