


import 'package:knights_tale/widget/core/Player.dart';

import '../location/GLocation.dart';

class Game{

  static Game Core = Game();

  Player player = Player();
  List<String> api = [];
  List<String> play = [];

  GLocation? selectedLocation = null;

}