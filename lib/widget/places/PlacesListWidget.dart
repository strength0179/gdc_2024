
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'GPlaces.dart';

class PlacesListWidget extends StatefulWidget{

  List<GPlaces> list;

  PlacesListWidget(this.list);

  @override
  State<StatefulWidget> createState() {
    return PlacesListWidgetState();
  }

}

class PlacesListWidgetState extends State<PlacesListWidget>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.list.length + 1,
        itemBuilder: (BuildContext context, int index) {
          TextStyle? style = Theme.of(context).textTheme.headlineMedium;

          if(index == 0)
            return Text("The bus station nearby:", style: style,);
          else
            return Text(widget.list[index -1].displaceName, style: style);
        });
  }

}