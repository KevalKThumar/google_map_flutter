import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_map_demo/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetCurrLocation extends StatefulWidget {
  const GetCurrLocation({super.key});

  @override
  State<GetCurrLocation> createState() => _GetCurrLocationState();
}

class _GetCurrLocationState extends State<GetCurrLocation> {
  var latitude = 0.0;
  var longitude = 0.0;
  bool isLoading = false; // Loading state variable

  Future<void> _getLocation() async {
    setState(() {
      isLoading = true; // Start loading
    });

    LocationService locationService = LocationService();
    var locationData = await locationService.getLocation();

    setState(() {
      isLoading = false; // Stop loading

      if (locationData != null) {
        latitude = locationData.latitude!;
        longitude = locationData.longitude!;
        markers.add(
          Marker(
            markerId: const MarkerId('2'),
            position: LatLng(latitude, longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(120),
            infoWindow: const InfoWindow(
              title: 'My Position',
              snippet: 'live location',
            ),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Location permission denied or not available",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.black,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // List<String> images = [
  //   'images/car_1.png',
  //   'images/car_2.png',
  //   'images/car_3.png',
  //   'images/car_4.png',
  //   'images/car_5.png',
  //   'images/car_6.png'
  // ];

  // List<LatLng> latlng = [
  //   const LatLng(21.709162, 70.576092),
  //   const LatLng(21.709164, 70.576094),
  //   const LatLng(21.709166, 70.576096),
  //   const LatLng(21.709168, 70.576098),
  //   const LatLng(21.709160, 70.576090),
  //   const LatLng(21.709170, 70.576100),
  // ];

  static const CameraPosition _kGooglePlex2 = CameraPosition(
    target: LatLng(22.303486, 70.793826),
    zoom: 12.4746,
  );

  List<Marker> markers = <Marker>[
    Marker(
      draggable: true,
      markerId: const MarkerId('1'),
      position: const LatLng(22.303486, 70.793826),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: const InfoWindow(
        title: 'Rajkot',
        snippet: 'India',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Stack(
          children: [
            if (isLoading)
              FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                child: const CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            else
              FloatingActionButton(
                onPressed: () async {
                  try {
                    final GoogleMapController controller =
                        await _controller.future;
                    await _getLocation();
                    controller.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(
                          latitude,
                          longitude,
                        ),
                        zoom: 14.4746,
                      )),
                    );
                    setState(() {
                      log("latitude: $latitude, longitude: $longitude");
                    });
                  } on Exception catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                        content: Text(
                          e.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                child: const Icon(
                  Icons.location_on,
                  size: 30,
                ),
              ),
          ],
        ),
        body: GoogleMap(
          myLocationEnabled: true,
          markers: Set<Marker>.of(markers),
          myLocationButtonEnabled: true,
          mapType: MapType.hybrid,
          zoomControlsEnabled: false,
          initialCameraPosition: _kGooglePlex2,
          compassEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
