import 'package:expenses/states/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(child: Text('Escolha um tema')),
                Switch(
                  value: false,
                  onChanged: (_) {},
                ),
              ],
            ),
            Expanded(child: Container()),
            Container(
              //padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
              width: double.infinity,
              child: FlatButton(
                color: Colors.blue,
                padding: EdgeInsets.fromLTRB(22, 14, 22, 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Text('Encerrar Sessão'),
                onPressed: () {
                  Provider.of<LoginState>(context).logout();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
