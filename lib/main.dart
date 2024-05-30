import 'package:flutter/material.dart';
import 'package:pukulenam/PartView/Cardview.dart';
import 'package:pukulenam/PartView/Profile.dart';
import 'package:pukulenam/UI/FormAdapter.dart';
import 'package:pukulenam/UI/MainView.dart';

import 'PartView/PukulEnam.dart';
import 'UI/ChatAdapter.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'Pukul Enam',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),

      home: CardList(),
    );
  }
}
