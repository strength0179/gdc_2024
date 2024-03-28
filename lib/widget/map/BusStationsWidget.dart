

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:knights_tale/widget/core/Game.dart';
import 'package:knights_tale/widget/location/GLocation.dart';
import 'package:knights_tale/widget/map/dialog/NotifyDialog.dart';

import '../SelectAreaPage.dart';
import '../api/SelectBusStation.dart';
import 'dart:convert';

import 'directions/DirectionUtil.dart';

class BusStationsWidget extends StatefulWidget {

  BusStationsWidget(GLocation gLocation, {super.key}){
    Game.Core.locations.add(gLocation);
  }

  void resetAll(List<GLocation> loc){
    Game.Core.locations.clear();
    Game.Core.locations.addAll(loc);
  }

  void reset(GLocation gLocation){
    Game.Core.locations.clear();
    Game.Core.locations.add(gLocation);
  }

  @override
  State<BusStationsWidget> createState() => BusStationsWidgetState();
}

class BusStationsWidgetState extends State<BusStationsWidget> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  GoogleMapController? controller;
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

    // InfoWindow infoWindow = InfoWindow(title: "[Demo Title]", snippet: 'DemoSnippet', onTap: (){});

    if(Game.Core.targetLocation != null){

      GLocation? movingLocation = Game.Core.movingLocation;
      sets.add(mark(movingLocation!.id+"_2",movingLocation!.latitude, movingLocation!.longitude));

    }
    else if(Game.Core.locations2.length != 0){
      Game.Core.locations2.forEach((element) {

        NotifyDialog dialog = NotifyDialog('Select this station 4.', 'Select this station 4.');
        dialog.setImageUrl('img/cat_march.jpg');
        dialog.setOkPressed(() {
          api.selected(Game.Core.player, element.address, element).then((value){
            Game.Core.selectedLocation = element;
            setState(() {

            });
          });
        });
        sets.add(mark(element.id, element.latitude, element.longitude, /*info: infoWindow,*/ builder: dialog.dialog));
      });
    }
    else if(Game.Core.selectedLocation != null){

      GLocation? selectedLocation = Game.Core.selectedLocation;
      NotifyDialog dialog = NotifyDialog('Cancel And Re-Select 2', 'Do you want to change your selection? 2');
      dialog.setOkPressed(() {
        // Navigator.pop(context, 'OK');
        selectedLocation = null;
        Game.Core.selectedLocation = null;
        setState(() {

        });
      });

      sets.add(mark(selectedLocation!.id+"_1", selectedLocation!.latitude, selectedLocation!.longitude, /*info: infoWindow,*/ builder: dialog.dialog));
    }
    else{
      Game.Core.locations.forEach((element) {

        NotifyDialog dialog = NotifyDialog('Select this station 1.', 'Select this station 2.');
        dialog.setImageUrl('img/cat_march.jpg');
        dialog.setOkPressed(() {
          api.selected(Game.Core.player, element.address, element).then((value){
            Game.Core.selectedLocation = element;
            setState(() {

            });
          });
        });
        sets.add(mark(element.id, element.latitude, element.longitude, /*info: infoWindow,*/ builder: dialog.dialog));
      });
    }
    return sets;
  }

  double latitudeDelta = 0, longtitudeDelta = 0;

  Future<void> freshMovingLocation() async{
    Game.Core.movingProgress += 0.01;
    double x = latitudeDelta * Game.Core.movingProgress;
    double y = longtitudeDelta * Game.Core.movingProgress;

    if(Game.Core.movingLocation != null){
      Game.Core.movingLocation!.latitude = Game.Core.selectedLocation!.latitude + x;
      Game.Core.movingLocation!.longitude = Game.Core.selectedLocation!.longitude + y;
    }

    // print('freshMoving1 ' + latitudeDelta.toString() + ',' + longtitudeDelta.toString() + ',' + x.toString() + ',' + y.toString());
    // print('freshMoving2 ' + Game.Core.movingProgress.toString());
    setState(() {});

    if(Game.Core.movingProgress >= 1){
      print("Game Challenge End.");
      if(Random().nextBool()){

        NotifyDialog winDialog = NotifyDialog("Yeah...", "You win.");
        winDialog.setImageUrl("img/cat_victory.jpg");
        winDialog.setOkPressed(() {
          Game.Core.movingLocation = null;
          Game.Core.selectedLocation = null;
          Game.Core.targetLocation = null;
          Game.Core.polyline = Set();
          Game.Core.locations2.clear();
          moveCamera();
          setState(() {});
        });

        showDialog(context: _scaffoldKey.currentContext!, builder: winDialog.dialog);
      }
      else{

        NotifyDialog loseDialog = NotifyDialog("Sorry...", "You lose.");
        loseDialog.setImageUrl("img/cat_lose.jpg");
        loseDialog.setOkPressed(() {
          Game.Core.movingLocation = null;
          Game.Core.selectedLocation = null;
          Game.Core.targetLocation = null;
          Game.Core.polyline = Set();
          Game.Core.locations2.clear();
          moveCamera();
          setState(() {});
        });


        showDialog(context: _scaffoldKey.currentContext!, builder: loseDialog.dialog);
      }
    }
    else{
      // sleep(Duration(milliseconds: 5000));
      Future.delayed(Duration(seconds: 1)).then((value) => freshMovingLocation());

    }
  }

  void targetNamePress(){
    GLocation element = Game.Core.locations2[camPosition()];
    DirectionUtil directionUtil = DirectionUtil();
    Game.Core.targetLocation = element;
    Game.Core.movingProgress = 0;

    directionUtil.direction(Game.Core.selectedLocation!, element).then((value){

      Game.Core.polyline = value;
      setState(() {});
      Game.Core.movingLocation = Game.Core.selectedLocation?.tmp();
      latitudeDelta = (Game.Core.targetLocation!.latitude - Game.Core.selectedLocation!.latitude);
      longtitudeDelta = (Game.Core.targetLocation!.longitude - Game.Core.selectedLocation!.longitude);
      freshMovingLocation();
    });

  }

  void busNamePress(){
    GLocation element = Game.Core.locations[camPosition()];
    api.selected(Game.Core.player, element.address, element).then((value){
      Game.Core.selectedLocation = element;

      api.target(Game.Core.player, element.address, element).then((value){
        // print(value.$2);

        Map<String, GLocation> buss = Map();
        Map<String, dynamic> body = json.decode(value.$2);
        (body['data'] as List<dynamic>).forEach((element) {
          // print('data : ' + element.toString());
          Map<String, dynamic> bus = element;
          GLocation gl = GLocation(double.parse(bus['lat']), double.parse(bus['lngt']), 0);
          gl.setId(bus['name']);
          buss[bus['name']] = gl;
        });

        buss.forEach((key, value) {
          Game.Core.locations2.add(value);
        });

        setState(() {

        });
      });

      setState(() {

      });
    });
  }

  LatLng getLatLng(GLocation gl){
    // print('LatLng [' + gl.id + ']' + gl.latitude.toString() + ',' +  gl.longitude.toString());
    return LatLng(gl.latitude, gl.longitude);
  }

  bool moving = false;
  void moveCamera(){
    if(!moving){
      moving = true;
      List<GLocation> list = (Game.Core.locations2.length != 0)?Game.Core.locations2:Game.Core.locations;
      controller!.getZoomLevel().then((value) {

        controller?.moveCamera(CameraUpdate.newLatLngZoom(getLatLng(list[camPosition()]), value)).then((value){
          // controller!.getZoomLevel().then((value1) => print('Camera zoomLevel1 ' + value1.toString()));
          moving = false;
          setState(() {

          });
        }, onError: (value){
          // controller!.getZoomLevel().then((value1) => print('Camera zoomLevel2 ' + value1.toString()));
          moving = false;
        });

      });
    }

  }
  
  Widget floatButton(){

    List<GLocation> list = (Game.Core.locations2.length != 0)?Game.Core.locations2:Game.Core.locations;

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 40),
      child: Row(children: [
        FloatingActionButton(
          onPressed: (){
            Game.Core.cameraposition += list.length - 1;
            Game.Core.cameraposition %= list.length;
            moveCamera();
            // setState(() {});
          },
          child: Icon(Icons.arrow_left),
        ),

        SizedBox(width: 20),

        FloatingActionButton.extended(onPressed: (){

          if(list == Game.Core.locations2){
            NotifyDialog dialog = NotifyDialog('Select this station 5.', list[camPosition()].id + '\r\nAttack this station');
            dialog.setImageUrl('img/cat_march.jpg');
            dialog.setOkPressed(targetNamePress);
            showDialog(context: _scaffoldKey.currentContext!, builder: dialog.dialog);
          }
          else{
            NotifyDialog dialog = NotifyDialog('Select this station 3.', list[camPosition()].id + '\r\nSelect this station');
            dialog.setImageUrl('img/cat_march.jpg');
            dialog.setOkPressed(busNamePress);
            showDialog(context: _scaffoldKey.currentContext!, builder: dialog.dialog);
          }



        }, label: Text(list[camPosition()].id)),

        SizedBox(width: 20),

        FloatingActionButton(
          onPressed: (){
            Game.Core.cameraposition += list.length + 1;
            Game.Core.cameraposition %= list.length;
            moveCamera();
          },
          child: Icon(Icons.arrow_right),
        )

      ],),
    );
  }



  int camPosition(){
    List<GLocation> list = (Game.Core.locations2.length != 0)?Game.Core.locations2:Game.Core.locations;
    return Game.Core.cameraposition % list.length;
  }

  @override
  Widget build(BuildContext context) {

    List<GLocation> list = (Game.Core.locations2.length != 0)?Game.Core.locations2:Game.Core.locations;
    CameraPosition _kGooglePlex = CameraPosition(
      target: getLatLng(list[camPosition()]),
      zoom: 15,
    );

    return Stack(
      children: [
        GoogleMap(
          key: _scaffoldKey,
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          markers: markerSets(),
          polylines: Game.Core.polyline,
          onMapCreated: (GoogleMapController controller) {
            // print('MapCreated [' + mapStyle.toString() + ']');
            _controller.complete(controller);
            this.controller = controller;
            controller.setMapStyle(getMapStyle());
          },
          zoomGesturesEnabled: false,
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: floatButton(),
        )

      ],
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