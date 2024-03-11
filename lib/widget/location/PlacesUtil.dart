

import 'package:knights_tale/widget/location/AddressUtil.dart';
import 'package:knights_tale/widget/places/GPlaces.dart';

import 'GLocation.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class PlacesUtil{

  AddressUtil addressUtil = AddressUtil();

  static const List<String> filter0 = ['[administrative_area_level_1, political]'];

  String parseArea(List<dynamic> results, String key, {List<String> filter = filter0}){

    StringBuffer area = StringBuffer();

    filter.forEach((filter_element) {

      results.forEach((element) {

        // print('result item : ' + element['formatted_address'].toString() + ', ' + element['types'].toString());
        // print(element);
        if(element['types'].toString() == filter_element){
          // print(element.toString() + "|" + filter_element);
          if(area.length > 0)area.write("- ");
          area.write(element[key].toString());
        }

      });


    });

    print('Area ' + area.toString());

    return area.toString().replaceAll(",", "-");
  }

  void readAddress(Map<String, dynamic> result, GLocation gl){

    List<dynamic> results = result['results'];
    gl.setAddress(parseArea(results, 'formatted_address'));

  }

  Future<String> address(double lat, double lng, Function(String) onValue) async{
    return await http.get(
        Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?language=en&latlng=' + lat.toString() + ',' + lng.toString() + '&key=AIzaSyA1UnG9L_jCJqLFQo8fwodJL2I1qYXcQes'))
        .then((value){
          // print(value.body);
          onValue(value.body);
          return value.body;
        }
    );
  }

  Future<void> places(GLocation gl, Function(List<GPlaces>) onValue) async {
    http.post(
      Uri.parse('https://places.googleapis.com/v1/places:searchNearby'),
      headers: <String, String>{
        'X-Goog-Api-Key': 'AIzaSyA1UnG9L_jCJqLFQo8fwodJL2I1qYXcQes',
        // 'includedTypes': '["restaurant"]',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Goog-FieldMask': 'places.displayName,places.location,places.id,places.addressComponents',
        // 'X-Goog-FieldMask': '*'
      },
      body: jsonEncode(<String, Object>{
        'includedTypes': [
          /*"restaurant",*/
          "bus_station",
          // "light_rail_station"
        ],
        'languageCode': 'en',
        'maxResultCount': 20,
        'locationRestriction': {
          'circle': {
            'center': {
              'latitude': gl.latitude,
              'longitude': gl.longitude},
            'radius': 1000.0
          }
        }
      }),
    ).then((value){
      if (value.statusCode == 201 || value.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        print('Places(new) API response : ');
        // print(value.body);


        Map<String, dynamic> result = jsonDecode(value.body) as Map<String, dynamic>;
        // print(result.toString());
        List<dynamic> places = result['places'];
        List<GPlaces> list = [];
        places.forEach((element) {
          // print(element.toString());
          // print(element['addressComponents'].toString());
          // readAddress(element['addressComponents'], GLocation(0, 0, 0));
          GPlaces places = GPlaces(element['location']['latitude'], element['location']['longitude'], element['displayName']['text']);
          // print(element['displayName']['text'] + ' -- area : ' + parseArea(element['addressComponents'], 'shortText', filter : ['[administrative_area_level_1, political]', '[country, political]']));
          places.setArea(parseArea(element['addressComponents'], 'shortText', filter : ['[administrative_area_level_1, political]', '[country, political]']));
          list.add(places);
        });

        onValue(list);

        // Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception(value.body);
      }
    });


  }


}