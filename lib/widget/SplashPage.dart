
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knights_tale/widget/MyHomePage.dart';
import 'package:knights_tale/widget/core/Game.dart';
import 'package:knights_tale/widget/location/GLocation.dart';
import 'package:knights_tale/widget/location/LocationUtil.dart';
import 'package:knights_tale/widget/location/PlacesUtil.dart';
import 'package:knights_tale/widget/places/PlacesListWidget.dart';

import 'PlacesListPage.dart';
import 'api/Register.dart';
import 'api/Splash.dart';
import 'core/Player.dart';

// const List<String> scopes = <String>[
//   'email',
//   'https://www.googleapis.com/auth/contacts.readonly',
// ];
//
// GoogleSignIn _googleSignIn = GoogleSignIn(
//   // Optional clientId
//   // clientId: 'your-client_id.apps.googleusercontent.com',
//   clientId: 'gamer-413312.appspot.com',
//   scopes: scopes,
// );

// Future<void> _handleSignIn() async {
//   try {
//     await _googleSignIn.signIn();
//   } catch (error) {
//     print(error);
//   }
// }

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.title});

  final String title;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String message = 'Loading Your Position';
  GetLocationUtil util = GetLocationUtil();
  PlacesUtil placesUtil = PlacesUtil();
  
  Splash splash = Splash();
  Register register = Register();

  void freshMessege(String m){
    setState(() {
      message = m;
    });
  }

  Future<GLocation> _determinePosition() async {

    print('request position');

    return await util.getLocation().then((value) async {

      GLocation gl = value!;

      if(gl != null){

        freshMessege('GetAddress...');

        placesUtil.address(gl.latitude, gl.longitude, (p0){

          Map<String, dynamic> result = jsonDecode(p0) as Map<String, dynamic>;
          placesUtil.readAddress(result, gl);
          print('Register with [' + gl.address + ']');

          Player player = Game.Core.player;

          if(player.hasData()){
            freshMessege('Loading ... Area is' + gl.address + '. Searching Bus Station.');
            searchBusStation(gl);
          }
          else{
            freshMessege('Register. Area is ... ' + gl.address);

            register.register(gl.address).then((value){

              // print(value);

              final jsonResult = json.decode(value.$2.toString());
              print('Return token : ' + jsonResult['data']['token']);

              player.set(
                  jsonResult['data']['name'],
                  jsonResult['data']['email'],
                  jsonResult['data']['area'],
                  jsonResult['data']['token'],
                  jsonResult['data']['id']
              );

              freshMessege('Searching Bus Station');
              searchBusStation(gl);

            });

          }

        });

      }

      return value;
    });
  }

  Widget map = Container();

  void searchBusStation(GLocation gl){
    placesUtil.places(gl, (list){
      // list.forEach((element) {
      //   print(element.show());
      // });

      if(list.length == 0){
        Navigator.of(context).pushAndRemoveUntil<dynamic>(
          MaterialPageRoute(
              builder: (context) => MyHomePage(title: 'Knight\'s Tale : MapPage', location: gl)
          ), (route) => false,
        );
      }
      else{
        Navigator.of(context).pushAndRemoveUntil<dynamic>(
          MaterialPageRoute(
              builder: (context) => MyHomePage(title: 'Knight\'s Tale : MapPage', list: list)
            // builder: (context) => PlacesListPage(title: 'Knight\'s Tale : MapPage', list: list)
          ), (route) => false,
        );
      }

    });
  }

  void readSplash(int code, String result){
    if(code == 200){
      final jsonResult = json.decode(result.toString());

      List<dynamic> api = jsonResult['api'];
      List<dynamic> play = jsonResult['play'];

      api.forEach((element) { Game.Core.api.add(element.toString());});
      play.forEach((element) { Game.Core.play.add(element.toString());});

      _determinePosition();

    }
    else{
      splash.splash().then((value){
        readSplash(value.$1, value.$2);
      });
    }
  }


  @override
  void initState() {
    super.initState();

    splash.splash().then((value){
          print('api return : [' + value.$1.toString() + '] '+ value.$2.toString());

          readSplash(value.$1, value.$2);
        });
  }

  @override
  Widget build(BuildContext context) {

    TextStyle? style = Theme.of(context).textTheme.headlineSmall;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:
          Stack(
            children: [
              Image(image: AssetImage('img/knight_in_bus.jpg')),
              Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        message,
                        style: style
                    ),

                  ],
                ),
              ),
            ],
          )

    );
  }
}