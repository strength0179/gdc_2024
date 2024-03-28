

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotifyDialog{

  String title;
  String msg;
  String? assetUrl = null;

  NotifyDialog(this.title, this.msg);

  void Function() pressed = (){};

  void setOkPressed(void Function() pressed){
    this.pressed = pressed;
  }

  void setImageUrl(String url){
    this.assetUrl = url;
  }

  List<Widget> contents(){

    if(assetUrl != null){
      return [
        Text(msg),
        // Image(image: AssetImage('img/cat_march.jpg')),
        Container(
          width: 200,
          // height: 200,
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: ExactAssetImage('img/cat_march.jpg'),
          //         fit: BoxFit.fitWidth
          //     )
          // ),
          child: Image(image: AssetImage(assetUrl!), fit: BoxFit.fitHeight),
        ),
      ];
    }
    else{
      return [
        Text(msg),
      ];
    }
  }

  Widget dialog(BuildContext context){
    return AlertDialog(
      title: Text(title),
      content: Column(
        children: contents()
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: (){
            Navigator.pop(context, 'OK');
            pressed();
          },
          child: Text('OK'),
        ),
      ],
    );
  }


}