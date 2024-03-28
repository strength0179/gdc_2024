
import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_polyline_points/flutter_polyline_points.dart";
// import "package:google_maps_directions/google_maps_directions.dart";
// import "package:google_maps_directions/google_maps_directions.dart" as gmd;
// import "package:google_maps_directions/google_maps_directions.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:google_maps_routes/google_maps_routes.dart";
import "package:knights_tale/widget/location/GLocation.dart";

import 'package:http/http.dart' as http;
import "../../api/Api.dart";


class DirectionUtil extends Api{


  Future<Set<Polyline>> direction(GLocation g1, GLocation g2) async {

    print('Direction ' + g1.id + '(' + g1.latitude.toString() + ',' + g1.longitude.toString() + ') to ' + g2.id + '(' + g2.latitude.toString() +',' + g2.longitude.toString() + ')');

    List<LatLng> points = [
      LatLng(g1.latitude, g1.longitude),
      LatLng(g2.latitude, g2.longitude),
    ];

    Set<Polyline> pls = Set();
    Polyline polyline = Polyline(
      polylineId: PolylineId("001"),
      points: points,
      color: Colors.red,
      width: 5
    );

    pls.add(polyline);
    return pls;

    // MapsRoutes route = new MapsRoutes();
    // await route.drawRoute(
    //     points,
    //     'Loute',
    //     Colors.green,
    //     'AIzaSyA2tQbNYT8aLTg1gVVrHfuHHXcYxEt9JBo');
    //
    // return route.routes;

    // Directions? directions = null;
    //
    // // Directions directions = await getDirections(
    // //   g1.latitude,
    // //   g1.longitude,
    // //   g2.latitude,
    // //   g2.longitude,
    // //   language: "en",
    // //   mode: 'transit'
    // // );
    //
    // final response = await http.get(
    //   Uri.https(
    //     "maps.googleapis.com",
    //     "/maps/api/directions/json",
    //     {
    //       'origin': g1.latitude.toString() + ',' + g1.longitude.toString(),
    //       'destination': g2.latitude.toString() +',' + g2.longitude.toString(),
    //       'key': 'AIzaSyA2tQbNYT8aLTg1gVVrHfuHHXcYxEt9JBo',
    //       'alternatives': true.toString(),
    //       'language': 'en',
    //       'mode': 'transit',
    //     },
    //
    //   ),
    //   headers: {
    //     'Access-Control-Allow-Origin' : '*',
    //     'Access-Control-Allow-Methods' : 'GET,PUT,PATCH,POST,DELETE',
    //     'Access-Control-Allow-Headers' : 'Origin, X-Requested-With, Content-Type, Accept'
    //   }
    // );
    //
    // if (response.statusCode == 200) {
    //   dynamic json = jsonDecode(response.body);
    //   if (json["status"] == "OK") {
    //     if ((json["routes"] as List).isEmpty) {
    //       throw DirectionsException(
    //         status: json["status"],
    //         message: json["error_message"],
    //         description: "No routes between this two points.",
    //       );
    //     } else {
    //       directions = Directions.fromJson(json);
    //     }
    //   } else {
    //     throw DirectionsException(
    //       status: json["status"],
    //       message: json["error_message"],
    //     );
    //   }
    // } else {
    //   throw DirectionsException(
    //     status: response.statusCode.toString(),
    //     message: response.body,
    //   );
    // }
    //
    // DirectionRoute route = directions.shortestRoute;
    //
    // List<LatLng> points = PolylinePoints().decodePolyline(route.overviewPolyline.points)
    //     .map((point) => LatLng(point.latitude, point.longitude))
    //     .toList();
    //
    // List<Polyline> polylines = [
    //   Polyline(
    //     width: 5,
    //     polylineId: PolylineId("UNIQUE_ROUTE_ID"),
    //     color: Colors.green,
    //     points: points,
    //   ),
    // ];
    //
    //
    // return Set.of(polylines);

  }



}