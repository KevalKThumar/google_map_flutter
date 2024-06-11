# Flutter Map Integration Project

This Flutter project demonstrates several advanced Google Map functionalities, including converting longitude and latitude to an address and vice versa, drawing polygons and polylines, adding custom markers, and fetching the user's current location.

## Features

1. **Convert Longitude and Latitude to Address and Vice Versa**

   - Implemented using the `geocoding` package.
   - Functions for converting coordinates to addresses and addresses to coordinates.

2. **Polygon and Polyline**

   - Draw polygons and polylines on the map using `google_maps_flutter` package.
   - Customizable shapes and paths.

3. **Custom Marker**

   - Add custom markers on the map.
   - Custom icons and info windows for markers.

4. **Get Current Location**
   - Fetch the user's current location using the `location` package.
   - Display current location on the map with a marker.

## Getting Started

### Prerequisites

Ensure you have Flutter installed. For installation instructions, visit the [official Flutter documentation](https://flutter.dev/docs/get-started/install).

### Setup

1. **Clone the repository:**

   ```sh
   git clone https://github.com/KevalKThumar/google_map_flutter
   cd google_map_flutter
   ```

2. **Install dependencies:**

   ```sh
   flutter pub get
   ```

3. **Configure Google Maps API key:**
   - Obtain an API key from the [Google Cloud Console](https://console.cloud.google.com/).
   - Add your API key to the `android/app/src/main/AndroidManifest.xml`:
     ```xml
     <meta-data
         android:name="com.google.android.geo.API_KEY"
         android:value="YOUR_API_KEY"/>
     ```
   - Add your API key to the `ios/Runner/AppDelegate.swift`:
     ```swift
     GMSServices.provideAPIKey("YOUR_API_KEY")
     ```

## Implementation Details

1. **_Convert Longitude and Latitude to Address:_**

```dart
import 'package:geocoding/geocoding.dart';

Future<String> getAddressFromLatLng(double lat, double lng) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
  Placemark place = placemarks[0];
  return "${place.street}, ${place.city}, ${place.country}";
}
```

2.  **_Convert Address to Longitude and Latitude:_**

```dart
import 'package:geocoding/geocoding.dart';
Future<List<Location>> getLatLngFromAddress(String address) async {
  List<Location> locations = await locationFromAddress(address);
  return locations;
}
```

3.  **_Drawing Polygon and Polyline_**

```dart
Polygon(
  polygonId: PolygonId('polygon_id'),
  points: polygonPoints,
  strokeWidth: 2,
  strokeColor: Colors.blue,
  fillColor: Colors.blue.withOpacity(0.1),
);

Polyline(
  polylineId: PolylineId('polyline_id'),
  points: polylinePoints,
  width: 5,
  color: Colors.red,
);

```

4.  **_Adding Custom Markers_**

```dart
Marker(
  markerId: MarkerId('marker_id'),
  position: LatLng(latitude, longitude),
  infoWindow: InfoWindow(title: 'Custom Marker'),
  icon: customIcon,
);

```

5. **Get Current Location**

```dart
import 'package:location/location.dart';
Future<LatLng> getCurrentLocation() async {
  Location location = new Location();
  LocationData currentLocation = await location.getLocation();
  return LatLng(currentLocation.latitude,
  currentLocation.longitude);
}

```

## Demo App

The demo app is available [here](https://drive.google.com/drive/u/0/folders/1fPIrjm8rL7B0pQEafvQAToEz5eFfuoze).

## Packages Used

`google_maps_flutter`: [https://pub.dev/packages/google_maps_flutter](https://pub.dev/packages/google_maps_flutter)

`geocoding`: [https://pub.dev/packages/geocoding](https://pub.dev/packages/geocoding)

`location`: [https://pub.dev/packages/location](https://pub.dev/packages/location)

