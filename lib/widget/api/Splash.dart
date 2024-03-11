

import 'Api.dart';

class Splash extends Api{


  Future<(int, String)> splash(){

    return api('script.google.com', 'macros/s/AKfycbz_pEsKhIrKuWnshzuaHo8DyJ9wEmGELlFYBj_tmIodZ3VED8A99LW7BwPqTBOQoOFt/exec');

  }


}