
class GLocation{

  double latitude;
  double longitude;
  double altitude;
  String error = '';
  String id = ''; //DisplayName of Geo-Places ()
  String snippet = '';
  bool hasError = false;

  GLocation(this.latitude, this.longitude, this.altitude);

  GLocation setError(bool e, String er){
    hasError = e;
    error = er;
    return this;
  }

  GLocation setId(String id){
    this.id = id;
    return this;
  }

  GLocation setSnippet(String s){
    snippet = s;
    return this;
  }


  String address = '';
  GLocation setAddress(String address){
    this.address = address;
    return this;
  }

  GLocation tmp(){
    return GLocation(latitude.toDouble(), longitude.toDouble(), altitude.toDouble());
  }

}