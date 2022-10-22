import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;

class LocationManager {
  static loc.Location location = loc.Location();

  static Future<bool> checkLocationPermission() async {
    var _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }
    var _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  static Future<loc.LocationData> getLocation() async {
    return await location.getLocation();
  }

  static Future<String> GetAddressFromLatLong(double lat, double lon) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
    Placemark place = placemarks[0];
    return ('${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}');
  }
}
