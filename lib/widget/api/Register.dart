

import 'package:knights_tale/widget/core/Game.dart';

import 'Api.dart';

class Register extends Api{


  Future<(int, String)> register(area){
    print('Api Register Area : ' + area.toString());
    Map<String, dynamic> query = {
      'func' : 'register',
      'name' : 'regName',
      'email' : 'regEmail',
      'area' : area
    };
    return api('script.google.com', Game.Core.api[0], queryParameters:  query);

  }


}