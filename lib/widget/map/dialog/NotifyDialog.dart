

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotifyDialog{

  String title;
  String msg;

  NotifyDialog(this.title, this.msg);

  void Function() pressed = (){};

  void setOkPressed(void Function() pressed){
    this.pressed = pressed;
  }

  Widget dialog(BuildContext context){
    return AlertDialog(
      title: Text(title),
      content: Text(msg),
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