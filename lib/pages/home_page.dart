import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Text('Expenses'),
        ),
      ),
    );
  }
}
