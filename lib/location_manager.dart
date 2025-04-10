import 'package:location/location.dart';

class LocationManager {
  Location location = Location();
  Future<bool> getPermission() async {
    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return false;
      } else {
        return true;
      }
    }
    if (permission == PermissionStatus.deniedForever) {
      return false;
    }
    return true;
  }

  Future<bool> getService() async {
    bool isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
      if (isServiceEnabled) {
        return true;
      } else {
        return false;
      }
    }
    return isServiceEnabled;
  }

  Future<bool> canGetLocation() async {
    bool service = await getService();
    bool permissiom = await getPermission();
    return service && permissiom;
  }
}
