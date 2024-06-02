import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class GooglePlaceApi extends StatefulWidget {
  const GooglePlaceApi({super.key});

  @override
  State<GooglePlaceApi> createState() => _GooglePlaceApiState();
}

class _GooglePlaceApiState extends State<GooglePlaceApi> {
  TextEditingController searchController = TextEditingController();
  var uuid = const Uuid();
  String sessionToken = '12345';

  List<dynamic> suggestions = [];

  @override
  void initState() {
    searchController.addListener(() {
      onChange();
    });
    super.initState();
  }

  void onChange() {
    getSuggestion(searchController.text);
  }

  void getSuggestion(String search) async {
    String kplacesApiKey = "AIzaSyBJjaF1M46Vf7LlRmBmNveXH-0izqXwFbQ";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$search&key=$kplacesApiKey&sessiontoken=$sessionToken';

    var response = await http.get(Uri.parse(request));

    var data = response.body.toString();

    log(data);

    if (response.statusCode == 200) {
      setState(() {
        suggestions = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Failed to load suggestion');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.black,
        title: const Text(
          'Google Place API',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            // textfild

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.mic),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),

            // suggestion
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      List<Location> locations = await locationFromAddress(
                        suggestions[index]['description'],
                      );

                      double latitude = locations[0].latitude;

                      double longitude = locations[0].longitude;

                      log('$latitude $longitude');
                    },
                    title: Text(suggestions[index]['description']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
