
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:knights_tale/widget/SignInWidget.dart';
import 'package:knights_tale/widget/location/GLocation.dart';

import 'map/BusStationsWidget.dart';
import 'places/GPlaces.dart';


class MyHomePage extends StatefulWidget {



  MyHomePage({super.key, this.title, this.location, this.list});

  String? title;
  GLocation? location;
  List<GPlaces>? list;

  String? getTitle(){
    if(title == null)
      return '';
    return title! + ' 1.0.21';
  }

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // String location = '';
  // GetLocationUtil util = GetLocationUtil();


  // Widget map = MapWidget(0, 0, 0);
  Widget map = Container();
  BusStationsWidget tMap = BusStationsWidget(GLocation(0, 0, 0));
  Widget buttom = Text('');

  @override
  void initState() {
    super.initState();

    if(widget.location != null) {
      tMap.reset(widget.location!);
    }
    else if(widget.list != null) {
      List<GLocation> gls = [];
      widget.list!.forEach((element) {
        gls.add(GLocation(element.latitude, element.longitude, 0).setId(element.displaceName).setAddress(element.area));
      });
      tMap.resetAll(gls);
    }

    map = tMap;

  }

  @override
  Widget build(BuildContext context) {

    TextStyle? style = Theme.of(context).textTheme.headlineMedium;

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.getTitle()!),
      ),
      body: Center(
        child: Stack(
          children: [

            map,

          ],
        )
      ),

    );
  }
}