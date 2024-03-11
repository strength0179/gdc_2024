
import 'package:flutter/services.dart';
import 'package:knights_tale/widget/location/GLocation.dart';
import 'package:location/location.dart';


class GetLocationUtil  {
  final Location location = Location();

  bool _loading = false;

  late GLocation gLocation;
  // LocationData? _location;
  String? _error;

  bool isLoading(){
    return _loading;
  }

  Future<GLocation?> getLocation() async {

    try {
      _loading = true;

      if(location.hasPermission() == PermissionStatus.denied){
        location.requestPermission();
      }

      await location.getLocation().then((value){

        _loading = false;

        if(value != null) {
          print('GetLocation ...' + value.toString() );
          gLocation = GLocation(value.latitude!, value.longitude!, 0);
        }
        else
          gLocation = GLocation(-2,  -2, -2);
        return value;
      });

      // print('returnn Location ...');
      return gLocation;

    } on PlatformException catch (err) {
      _error = err.code;
      _loading = false;
      return GLocation(-1, -1, -1).setError(true, _error!);
    }
  }

}