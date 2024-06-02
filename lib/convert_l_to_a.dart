import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConvertLToA extends StatefulWidget {
  const ConvertLToA({super.key});

  @override
  State<ConvertLToA> createState() => _ConvertLToAState();
}

class _ConvertLToAState extends State<ConvertLToA> {
  String stAddress = "";
  String stAddress2 = "";
  double? latitude;
  double? longitude;

  TextEditingController searchController = TextEditingController();
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Conversion L to A',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        elevation: 1,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardAppearance: Brightness.dark,
              controller: searchController,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Longitude Latitude:-\n $stAddress",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Address:- \n $stAddress2",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width - 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  try {
                    List<Location> locations =
                        await locationFromAddress(searchController.text);

                    List<Placemark> placemarks = await placemarkFromCoordinates(
                        locations.last.latitude, locations.last.longitude);

                    setState(() {
                      latitude = locations.last.latitude;
                      longitude = locations.last.longitude;
                      stAddress =
                          "${locations.last.latitude}, ${locations.last.longitude}";
                      stAddress2 =
                          "${placemarks.last.postalCode}, ${placemarks.last.street}, ${placemarks.last.administrativeArea}, ${placemarks.last.country}";

                      // Update the camera position on the map
                      if (mapController != null) {
                        mapController!.animateCamera(
                          CameraUpdate.newLatLng(
                            LatLng(latitude!, longitude!),
                          ),
                        );
                      }
                    });
                  } on Exception catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          e.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 3),
                        dismissDirection: DismissDirection.horizontal,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Convert L to A',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Expanded(
            child: latitude != null && longitude != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latitude!, longitude!),
                        zoom: 18.0,
                      ),
                      compassEnabled: true,
                      mapToolbarEnabled: true,
                      mapType: MapType.satellite,
                      trafficEnabled: true,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId('location'),
                          position: LatLng(latitude!, longitude!),
                          infoWindow: InfoWindow(
                            title: '${latitude!} ,${longitude!}',
                            snippet: searchController.text,
                          ),
                        ),
                      },
                    ),
                  )
                : const Center(child: Text('No location selected')),
          ),
        ],
      ),
    );
  }
}
