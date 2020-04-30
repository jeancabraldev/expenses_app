import 'package:expenses/widgets/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './pages/home_page.dart';
import './pages/add_page.dart';
import './pages/login_page.dart';
import './states/login_state.dart';

/*Paleta de cores: https://coolors.co/5c03fa-2e2d88-091f92-32127a-4b0082*/

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(
      builder: (BuildContext context) => LoginState(),
      //builder: (BuildContext context ) => LoginState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Montserrat',
          textTheme: TextTheme(
            body1: TextStyle(
              fontSize: 12
            ),
          ),
        ),
        onGenerateRoute: (settings) {
          Rect buttonRect = settings.arguments;
          return PageTransition(
            page: AddPage(
              buttonRect: buttonRect,
            )
          );
        },
        routes: {
          '/': (BuildContext context) {
            var state = Provider.of<LoginState>(context);
            if (state.isLoggedIn()) {
              return HomePage();
            } else {
              return LoginPage();
            }
          },
        },
      ),
    );
  }
}
