import 'package:flutter/material.dart';

class PageTransition extends PageRouteBuilder {
  final Widget page;
  final Widget backgound;

  PageTransition({this.page, this.backgound}) : super(
    transitionDuration: Duration(microseconds: 1),
    pageBuilder: (context, animation1, animation2) => page,
    transitionsBuilder: (context, animation1, animation, child) => Stack(
      children: <Widget>[
        backgound,
        page,

      ],
    ),
  );
}