import 'package:expenses/pages/add_page.dart';
import 'package:expenses/widgets/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './pages/details_page.dart';
import './pages/home_page.dart';
import './pages/login_page.dart';
import './states/login_state.dart';

/*Paleta de cores:
  https://coolors.co/50514f-f25f5c-ffe066-247ba0-70c1b3
*/

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
            body1: TextStyle(fontSize: 13),
            caption: TextStyle(fontSize: 16)
          ),
        ),
        onGenerateRoute: (settings) {

          if (settings.name == '/details') {
          DetailsParams params = settings.arguments;
            return MaterialPageRoute(builder: (BuildContext context) {
              return DetailsPage(
                params: params,
              );
            });
          } else if(settings.name == '/add'){
            Rect buttonReact = settings.arguments;
            return PageTransition(
              page: AddPage(
                buttonRect: buttonReact,
              )
            );
          }
          return null;
        },

//        onGenerateRoute: (settings) {
//          DetailsParams params = settings.arguments;
//          if (settings.name == '/details') {
//            return MaterialPageRoute(builder: (BuildContext context) {
//              return DetailsPage(
//                params: params,
//              );
//            });
//          }
//          return null;
//        },

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
