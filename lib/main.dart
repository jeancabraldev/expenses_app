import 'package:flutter/material.dart';
import './pages/home_page.dart';
import './pages/add_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      routes: {
        '/': (BuildContext context) => HomePage(),
        '/add': (BuildContext context) => AddPage(),
      },
    );
  }
}