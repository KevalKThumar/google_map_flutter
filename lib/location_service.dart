import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart' as perm;

class LocationService {
  loc.Location location = loc.Location();

  Future<bool> _handleLocationPermission() async {
    perm.PermissionStatus permissionStatus =
        await perm.Permission.location.status;

    if (permissionStatus == perm.PermissionStatus.granted) {
      return true;
    } else if (permissionStatus == perm.PermissionStatus.denied) {
      permissionStatus = await perm.Permission.location.request();
      return permissionStatus == perm.PermissionStatus.granted;
    } else {
      // Handle case when permission is permanently denied
      await perm.openAppSettings();
      return false;
    }
  }

  Future<loc.LocationData?> getLocation() async {
    bool _serviceEnabled;

    // Check if the location service is enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    // Check and request location permissions
    bool hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      return null;
    }

    // Return the current location
    return await location.getLocation();
  }
}
