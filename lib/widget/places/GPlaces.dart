
class GPlaces{

  double latitude = -1, longitude = -1;
  String displaceName = "";

  GPlaces(this.latitude, this.longitude, this.displaceName);

  String show(){
    return displaceName + ' (' + latitude.toString() + ',' + longitude.toString() + ')';
  }


  String area = '';
  void setArea(String area){
    this.area = area;
  }

}