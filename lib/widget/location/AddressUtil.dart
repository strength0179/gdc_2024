
class AddressUtil{

  String area(result){
    print('Parse Area');
    List<dynamic> results = result['results'];
    StringBuffer buffer = StringBuffer();
    results.forEach((element) {
      print(element.toString());
    });
    print('Parse Area Done');

    return '';
  }

}