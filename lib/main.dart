import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:knights_tale/widget/SignInWidget.dart';

import 'widget/map/BusStationsWidget.dart';
import 'widget/MyHomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'widget/SplashPage.dart';

Future<void> main() async {

  //AIzaSyA2tQbNYT8aLTg1gVVrHfuHHXcYxEt9JBo ANDROID

  runApp(const MyApp());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value){
    print('Firebase initalize');
  });

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Knight\'s tale',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MapWidget(),
      // home: const SignInWidget(),
      // home: const MyHomePage(title: 'Knight\'s Tale : MapPage'),
      home: const SplashPage(title: 'Knight\'s Tale : SplashPage'),
      // routes: {
      //   '/': (context) => SplashPage(title: 'Knight\'s Tale : MapPage'),
      //   '/map': (context) => MyHomePage(title: 'Knight\'s Tale : MapPage'),
      // },
    );
  }
}


