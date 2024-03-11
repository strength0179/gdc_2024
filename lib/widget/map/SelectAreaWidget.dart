

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:knights_tale/widget/core/Game.dart';
import 'package:knights_tale/widget/location/GLocation.dart';

import '../api/SelectBusStation.dart';

class SelectAreaWidget extends StatefulWidget {

  List<GLocation> locations = [];
  // GLocation gLocation;

  // double longitude, latitude, altitude;

  SelectAreaWidget(GLocation gLocation, {super.key}){
    locations.add(gLocation);
  }

  void resetAll(List<GLocation> loc){
    locations.clear();
    locations.addAll(loc);
  }

  void reset(GLocation gLocation){
    locations.clear();
    locations.add(gLocation);
  }

  @override
  State<SelectAreaWidget> createState() => SelectAreaWidgetState();
}

class SelectAreaWidgetState extends State<SelectAreaWidget> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  String? mapStyle = null;
  GLocation? selectedLocation = null;
  SelectBusStation api = SelectBusStation();

  Marker mark(String id, double latitude, double longitude, {InfoWindow? info = null, Widget Function(BuildContext)? builder = null}){
    if(info != null){
      return Marker(
        visible: true,
        markerId: MarkerId(id),
        position: LatLng(latitude, longitude),
        // infoWindow: info
        onTap: (){

          showDialog(context: context, builder: builder!);
        }
      );
    }
    else{
      return Marker(
        visible: true,
        markerId: MarkerId(id),
        position: LatLng(latitude, longitude),
      );
    }

  }

  Set<Marker> markerSets(){

    Set<Marker> sets = {};

    if(selectedLocation != null){

      InfoWindow infoWindow = InfoWindow(
          title: "[" + selectedLocation!.id + "]",
          snippet: 'Click -> Cancel and re-select.',
          onTap: (){
            print('Tap to cancel marker ' + selectedLocation!.id);
            selectedLocation = null;
            setState(() {

            });
          }
      );

      sets.add(mark(selectedLocation!.id+"_1", selectedLocation!.latitude, selectedLocation!.longitude, info: infoWindow, builder: (context){
        return AlertDialog(
          title: const Text('Cancel And Re-Select'),
          content: const Text('Do you want to change your selection?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: (){
                Navigator.pop(context, 'OK');
                selectedLocation = null;
                setState(() {

                });

              },
              child: const Text('OK'),
            ),
          ],
        );
      }));
    }
    else{
      widget.locations.forEach((element) {
        InfoWindow infoWindow = InfoWindow(
            title: element.id,
            snippet: 'Click -> Select this station.',
            onTap: (){
              print('Tap on marker ' + element.id);

              api.selected(Game.Core.player, element.address, element).then((value){
                selectedLocation = element;
                setState(() {

                });
              });

            }
        );

        sets.add(mark(element.id, element.latitude, element.longitude, info: infoWindow, builder: (context){
          return AlertDialog(
            title: const Text('Select this station.'),
            content: const Text('Select this station.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: (){
                  Navigator.pop(context, 'OK');
                  api.selected(Game.Core.player, element.address, element).then((value){
                    selectedLocation = element;
                    setState(() {

                    });
                  });

                },
                child: const Text('OK'),
              ),
            ],
          );
        }));
      });
    }



    return sets;
  }

  @override
  Widget build(BuildContext context) {

    CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(widget.locations[0].latitude, widget.locations[0].longitude),
      zoom: 14.4746,
    );

    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      // markers: {
      //   mark("self", widget.locations[0].latitude, widget.locations[0].longitude)
      // },
      markers: markerSets(),
      onMapCreated: (GoogleMapController controller) {
        print('MapCreated [' + mapStyle.toString() + ']');
        _controller.complete(controller);
        controller.setMapStyle(getMapStyle());
      },
    );

  }

}

String getMapStyle(){

  return "[{\"elementType\": \"labels\",\"stylers\": [{\"visibility\": \"off\"}]}," +
  "{\"featureType\": \"administrative\",\"elementType\": \"geometry\",\"stylers\": [{\"visibility\": \"off\"}]}," +
  "{\"featureType\": \"administrative.land_parcel\",\"stylers\": [{\"visibility\": \"off\"}]}," +
  "{\"featureType\": \"administrative.neighborhood\",\"stylers\": [{\"visibility\": \"off\"}]}," +
  "{\"featureType\": \"poi\",\"stylers\": [{\"visibility\": \"off\"}]}," +
  "{\"featureType\": \"road\",\"elementType\": \"labels.icon\",\"stylers\": [{\"visibility\": \"off\"}]}," +
  "{\"featureType\": \"road.arterial\",\"elementType\": \"labels\",\"stylers\": [{\"visibility\": \"off\"}]}," +
  "{\"featureType\": \"road.highway\",\"elementType\": \"labels\",\"stylers\": [{\"visibility\": \"off\"}]}," +
  "{\"featureType\": \"road.local\",\"stylers\": [{\"visibility\": \"off\"}]}," +
  "{\"featureType\": \"transit\",\"stylers\": [{\"visibility\": \"off\"}]}]";

}