import 'package:expenses/states/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final Function onLoginSuccess;

  const LoginPage({Key key, this.onLoginSuccess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<LoginState>(
          builder: (BuildContext context, LoginState value, Widget child) {
            if(value.isLoading()){
              return CircularProgressIndicator();
            }else{
              return child;
            }
          },
          child: RaisedButton(
            child: Text('Sign In'),
            onPressed: () {
              Provider.of<LoginState>(context).login();
            },
          ),
        ),
      ),
    );
  }
}
