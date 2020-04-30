import 'package:flutter/material.dart';

class PageTransition extends PageRouteBuilder {
  final Widget page;

  PageTransition({this.page}) : super(
    pageBuilder: (context, animation1, animation2) => page,
    transitionsBuilder: (context, animation1, animation, child) => page,
  );
}