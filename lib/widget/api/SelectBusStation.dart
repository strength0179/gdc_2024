

import 'package:knights_tale/widget/core/Game.dart';

import '../core/Player.dart';
import '../location/GLocation.dart';
import 'Api.dart';

class SelectBusStation extends Api{


  Future<(int, String)> selected(Player player, String area, GLocation location){

    Map<String, dynamic> query = {
      'func' : 'add',
      'id' : player.id,
      'player' : player.name,
      'name' : location.id,
      'latitude' : location.latitude.toString(),
      'longtitude' : location.longitude.toString(),
      'area' : area,
    };
    return api('script.google.com', Game.Core.play[0], queryParameters:  query);

  }


}