
import 'package:http/http.dart' as http;
import 'package:fetch_client/fetch_client.dart' as web;
import 'package:http/retry.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


class Api{

  http.Client getClient(){
    if(kIsWeb){
      return web.FetchClient();
    }
    else
      return http.Client();

  }

  Future<(int, String)> api(String url, String param, {Map<String, dynamic>? queryParameters}) async {

    String? result = null;

    // final client = RetryClient(getClient());
    //
    // try {
    //   result = await client.read(Uri.http(url, param));
    // }
    // catch(exception){
    //   print(exception.toString());
    //   result = exception.toString();
    // }
    // finally {
    //   client.close();
    // }

    Map<String, dynamic> query = {};
    if(queryParameters != null){
      query.addAll(queryParameters);
    }

    // Uri uri0 = Uri.https(url, param, {});
    // print('Api URL0 [' + uri0.toString() + ']' );

    // Uri uri = Uri.https(url, Uri.encodeComponent(param), {});
    // Uri uri = Uri.https(url, param, {});
    Uri uri = Uri.https(url, param, query);


    print('Api URL [' + url + '/' + param + ']' );

    http.Response response = await http.get(uri);

    print('API Return [' + response.statusCode.toString() + ']');
    result = response.body;

    return (response.statusCode, result);
  }



}