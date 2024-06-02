// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineScreen extends StatefulWidget {
  const PolylineScreen({super.key});

  @override
  _PolylineScreenState createState() => _PolylineScreenState();
}

class _PolylineScreenState extends State<PolylineScreen> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(21.708933, 70.577150),
    zoom: 17.4746,
  );

  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};

  List<LatLng> polylineCoordinates = [
    const LatLng(21.709043, 70.578953),
    const LatLng(21.708999, 70.577747),
    const LatLng(21.709009, 70.577312),
    const LatLng(21.708933, 70.577150),
    const LatLng(21.708895, 70.576756),
    const LatLng(21.709176, 70.576676),
    const LatLng(21.709202, 70.576226),
    const LatLng(21.709153, 70.576097),
  ];

  @override
  void initState() {
    super.initState();

    addMarkers();
  }

  void addMarkers() {
    for (int i = 0; i < polylineCoordinates.length; i++) {
      if (polylineCoordinates.first == polylineCoordinates[i] ||
          polylineCoordinates.last == polylineCoordinates[i]) {
        markers.add(
          Marker(
            markerId: MarkerId(i.toString()),
            position: polylineCoordinates[i],
            icon: i != 0
                ? BitmapDescriptor.defaultMarker
                : BitmapDescriptor.defaultMarkerWithHue(120),
            infoWindow: InfoWindow(
              title: i == 0 ? 'Start' : 'End',
              snippet: i == 0 ? 'current' : 'destination',
            ),
          ),
        );
      }

      setState(() {});
      polylines.add(
        Polyline(
          polylineId: const PolylineId('1'),
          color: Colors.green,
          points: polylineCoordinates,
          width: 3,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.satellite,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers,
        polylines: polylines,
      )),
    );
  }
}
