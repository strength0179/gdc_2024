

import 'package:shared_preferences/shared_preferences.dart';

class Player{

  String? name;
  String? email;
  String? area;
  String? token;
  String? id;

  Player(){

    SharedPreferences.getInstance().then((value){

      SharedPreferences v = value as SharedPreferences;
      name = v.getString("name");
      email = v.getString("email");
      area = v.getString("area");
      token = v.getString("token");
      id = v.getString("id");

      return value;
    });

  }


  void set(String n, String m, String a, String t, String i){
    name = n;
    email = m;
    area = a;
    token = t;
    id = i;

    SharedPreferences.getInstance().then((value){

      SharedPreferences v = value as SharedPreferences;
      v.setString("name", name!);
      v.setString("email", email!);
      v.setString("area", area!);
      v.setString("token", token!);
      v.setString("id", id!);
      return value;
    });
  }

  bool hasData(){

    return (name != null) && (token != null) && (id != null);

  }

}