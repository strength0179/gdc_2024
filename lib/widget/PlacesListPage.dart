
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knights_tale/widget/MyHomePage.dart';
import 'package:knights_tale/widget/location/GLocation.dart';
import 'package:knights_tale/widget/location/LocationUtil.dart';
import 'package:knights_tale/widget/location/PlacesUtil.dart';
import 'package:knights_tale/widget/places/PlacesListWidget.dart';

import 'places/GPlaces.dart';


class PlacesListPage extends StatefulWidget {
  PlacesListPage({super.key, required this.title, required this.list});

  final String title;
  List<GPlaces> list;

  @override
  State<PlacesListPage> createState() => PlacesListPageState();
}

class PlacesListPageState extends State<PlacesListPage> {

  Widget map = Container();
  Widget buttom = Text('');

  @override
  void initState() {
    super.initState();
    buttom = PlacesListWidget(widget.list);
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
              Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    buttom

                  ],
                ),
              ),
            ],
          )

    );
  }
}