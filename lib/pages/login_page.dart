import 'package:expenses/states/login_state.dart';
import 'package:expenses/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final Function onLoginSuccess;

  const LoginPage({Key key, this.onLoginSuccess}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Image.asset('assets/images/finance5.png'),
            ),
            Text(
              'Minhas finanças',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: ColorsLayout.primaryColor()),
            ),
            Text(
              'Seu App de controle financeiro',
              style: Theme.of(context).textTheme.caption,
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Consumer<LoginState>(
              builder: (BuildContext context, LoginState value, Widget child) {
                if (value.isLoading()) {
                  return CircularProgressIndicator(
                    backgroundColor: ColorsLayout.categoryColorCards(),
                  );
                } else {
                  return child;
                }
              },
              child: FlatButton(
                color: ColorsLayout.secondaryColor(),
                padding: EdgeInsets.fromLTRB(22, 14, 22, 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  'Faça login com Google',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                onPressed: () {
                  Provider.of<LoginState>(context).login();
                },
              ),
            ),
            Expanded(
              child: Container(),
            ),
//            Padding(
//              padding: const EdgeInsets.all(28),
//              child: RichText(
//                textAlign: TextAlign.center,
//                text: TextSpan(
//                    style: Theme.of(context).textTheme.body1,
//                    text: 'Para usar este aplicativo, você concordar com os',
//                    children: [
//                      TextSpan(
//                        text: ' termos de serviços',
//                        recognizer: _recognizer1,
//                        style: Theme.of(context)
//                            .textTheme
//                            .body1
//                            .copyWith(fontWeight: FontWeight.bold),
//                      ),
//                      TextSpan(text: ' e '),
//                      TextSpan(
//                          text: 'politica de privacidade',
//                          recognizer: _recognizer2,
//                          style: Theme.of(context)
//                              .textTheme
//                              .body1
//                              .copyWith(fontWeight: FontWeight.bold)),
//                    ]),
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}
