

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:knights_tale/widget/core/Game.dart';
import 'package:knights_tale/widget/location/GLocation.dart';
import 'package:knights_tale/widget/map/dialog/NotifyDialog.dart';

import '../SelectAreaPage.dart';
import '../api/SelectBusStation.dart';

class BusStationsWidget extends StatefulWidget {

  List<GLocation> locations = [];
  // GLocation gLocation;

  // double longitude, latitude, altitude;

  BusStationsWidget(GLocation gLocation, {super.key}){
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
  State<BusStationsWidget> createState() => BusStationsWidgetState();
}

class BusStationsWidgetState extends State<BusStationsWidget> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  String? mapStyle = null;
  SelectBusStation api = SelectBusStation();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Marker mark(String id, double latitude, double longitude, {InfoWindow? info = null, Widget Function(BuildContext)? builder = null}){
    if(info != null){
      return Marker(
        visible: true,
        markerId: MarkerId(id),
        position: LatLng(latitude, longitude),
        // infoWindow: info
        onTap: (){

          showDialog(context: _scaffoldKey.currentContext!, builder: builder!);
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

    InfoWindow infoWindow = InfoWindow(
        title: "[Demo Title]",
        snippet: 'DemoSnippet',
        onTap: (){}
    );

    if(Game.Core.selectedLocation != null){

      GLocation? selectedLocation = Game.Core.selectedLocation;
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

        NotifyDialog dialog = NotifyDialog('Select this station 1.', 'Select this station 2.');
        dialog.setOkPressed(() {
          api.selected(Game.Core.player, element.address, element).then((value){
            Game.Core.selectedLocation = element;
            Navigator.of(_scaffoldKey.currentContext!).pushAndRemoveUntil<dynamic>(
              MaterialPageRoute(
                  builder: (context) => SelectAreaPage(title: 'Knight\'s Tale : SelectAreaPage', location: element),
                // builder: (context) => PlacesListPage(title: 'Knight\'s Tale : MapPage', list: list)
              ), (route) => false,
            );
            // setState(() {
            //
            // });
          });
        });
        sets.add(mark(element.id, element.latitude, element.longitude, info: infoWindow, builder: dialog.dialog));
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
      key: _scaffoldKey,
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