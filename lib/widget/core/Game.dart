


import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:knights_tale/widget/core/Player.dart';

import '../location/GLocation.dart';

class Game{

  static Game Core = Game();

  Player player = Player();
  List<String> api = [];
  List<String> play = [];

  List<GLocation> locations = [];
  List<GLocation> locations2 = [];
  Set<Polyline> polyline = Set();

  int cameraposition = 0;

  GLocation? selectedLocation = null;
  GLocation? targetLocation = null;
  GLocation? movingLocation = null;
  double movingProgress = 0;
}