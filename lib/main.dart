import 'package:flutter/material.dart';
import 'package:himage/pages/home/home.page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'himage',
      theme: ThemeData(
        primaryColor: Color(0xff303030),
        accentColor: Color(0xfff3c669),
      ),
      home: HomePage(),
    );
  }
}
