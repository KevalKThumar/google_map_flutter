// ignore_for_file: null_argument_to_non_null_type

import 'dart:async';
import 'dart:ui' as ui;

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'coustom_info_window.dart';

class CustomIcone extends StatefulWidget {
  const CustomIcone({super.key});

  @override
  State<CustomIcone> createState() => _CustomIconeState();
}

class _CustomIconeState extends State<CustomIcone> {
  Uint8List? markerImages;

  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  static const CameraPosition _kGooglePlex2 = CameraPosition(
    target: LatLng(21.709160, 70.576095),
    zoom: 14.4746,
  );

  Future<Uint8List> getBytesFromAssetes(String path, int width) async {
    try {
      ByteData data = await rootBundle.load(path);
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
          targetHeight: width);
      ui.FrameInfo fi = await codec.getNextFrame();

      return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
          .buffer
          .asUint8List();
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

      return Future.value(null);
    }
  }

  List<String> images = [
    'images/car_1.png',
    'images/car_2.png',
    'images/car_3.png',
    'images/car_4.png',
    'images/car_5.png',
    'images/car_6.png'
  ];

  final List<Marker> marker = <Marker>[];

  List<LatLng> latlng = [
    const LatLng(21.709282, 70.572612),
    const LatLng(21.705364, 70.573594),
    const LatLng(21.707446, 70.579476),
    const LatLng(21.702528, 70.578358),
    const LatLng(21.700110, 70.574130),
    const LatLng(21.706750, 70.576110),
  ];

  List<String> title = [
    'Car 1',
    'Car 2',
    'Car 3',
    'Car 4',
    'Car 5',
    'Car 6',
  ];

  List<String> description = [
    'Car 1 description',
    'Car 2 description',
    'Car 3 description',
    'Car 4 description',
    'Car 5 description',
    'Car 6 description',
  ];

  List<String> imgUrl = [
    "https://source.unsplash.com/random/100×200",
    "https://source.unsplash.com/random/100×200",
    "https://source.unsplash.com/random/100×200",
    "https://source.unsplash.com/random/100×200",
    "https://source.unsplash.com/random/100×200",
    "https://source.unsplash.com/random/100×200",
  ];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    for (var i = 0; i < images.length; i++) {
      final Uint8List markerIcon = await getBytesFromAssetes(images[i], 200);
      marker.add(
        Marker(
            markerId: MarkerId(
              i.toString(),
            ),
            onTap: () {
              customInfoWindowController.addInfoWindow!(
                InfoWindowContainer(
                  imgUrl: imgUrl[i],
                  title: title[i],
                  description: description[i],
                ),
                latlng[i],
              );
            },
            position: latlng[i],
            icon: BitmapDescriptor.fromBytes(markerIcon),
            infoWindow: InfoWindow(title: "${i + 1} th marker")),
      );
    }
    setState(() {});
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: Set<Marker>.of(marker),
              mapType: MapType.hybrid,
              zoomControlsEnabled: false,
              onTap: (argument) {
                customInfoWindowController.hideInfoWindow!();
              },
              onCameraMove: (position) {
                customInfoWindowController.onCameraMove!();
              },
              initialCameraPosition: _kGooglePlex2,
              compassEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                customInfoWindowController.googleMapController = controller;
              },
            ),
            CustomInfoWindow(
              controller: customInfoWindowController,
              height: 200,
              width: 200,
              offset: 75
            )
          ],
        ),
      ),
    );
  }
}
