import 'dart:ui';
import 'package:expenses/repository/expenses_repository.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses/states/login_state.dart';
import 'package:expenses/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../widgets/month.dart';
import '../utils/colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var globalKey = RectGetter.createGlobalKey();
  Rect buttonRect;

  //Controllers
  PageController _pageViewController;

  int currentPage = DateTime.now().month - 1;
  bool bottomBar = true;

  Stream<QuerySnapshot> _query;
  GraphType currentType = GraphType.LINES;

  @override
  void initState() {
    super.initState();

    _pageViewController =
        PageController(initialPage: currentPage, viewportFraction: 0.4);

    setupNotificationPlugin();
  }

  //Criando botões
  Widget _bottomAction(IconData icon, Function callback) {
    return InkWell(
      child: Icon(icon, size: 24),
      onTap: callback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesRepository>(
      builder: (BuildContext context, ExpensesRepository db, Widget child) {
        var user = Provider.of<LoginState>(context).currentUser();
        _query = db.queryMonth(currentPage + 1);

        return Scaffold(
          bottomNavigationBar: BottomAppBar(
            notchMargin: 5,
            shape: CircularNotchedRectangle(),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _bottomAction(FontAwesomeIcons.chartLine, () {
                    setState(() {
                      currentType = GraphType.LINES;
                    });
                  }),
                  _bottomAction(Icons.pie_chart, () {
                    setState(() {
                      currentType = GraphType.PIE;
                    });
                  }),
                  SizedBox(
                    width: 50,
                  ),
                  _bottomAction(Icons.account_balance_wallet, () {}),
                  _bottomAction(Icons.settings, () {
                    Navigator.pushNamed(context, '/settings');
                  })
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: RectGetter(
            key: globalKey,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                buttonRect = RectGetter.getRectFromKey(globalKey);
                Navigator.of(context).pushNamed('/add', arguments: buttonRect);
              },
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _query,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> data) {
                    //Verificando se tem dados
                    if (data.connectionState == ConnectionState.active) {
                      if (data.data.documents.length > 0) {
                        return Month(
                          days: daysInMonth(currentPage + 1),
                          documents: data.data.documents,
                          graphType: currentType,
                          month: currentPage,
                        );
                      } else {
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/images/not_found.png'),
                              SizedBox(height: 80),
                              Text('Adicione uma despesa para começar!')
                            ],
                          ),
                        );
                      }
                    }
                    return Container(
                      height: MediaQuery.of(context).size.height - 148,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: ColorsLayout.categoryColorCards(),
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                  height: 70,
                  color: Colors.transparent,
                  child: _selector(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Controlando os meses da PageView
  Widget _pageItem(String name, int position) {
    var _alignment; //Controlando alinhamento dos itens na pageView

    //Destacando o mês selecionado
    final selected = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    //Desfacando os meses que não estão selecionados
    final unSelected =
        TextStyle(fontSize: 16, color: Colors.black26.withOpacity(.2));

    /*Verificando se a posição é igual a página selecionada,
    cajo seja verdadeiro o conteúdo será centralizado*/
    if (position == currentPage) {
      _alignment = Alignment.center;
    } else if (position > currentPage) {
      _alignment = Alignment.centerRight;
    } else {
      _alignment = Alignment.centerLeft;
    }

    return Align(
      alignment: _alignment,
      child: Text(
        name,
        style: position == currentPage ? selected : unSelected,
      ),
    );
  }

  Widget _selector() {
    return SizedBox.fromSize(
      size: Size.fromHeight(50),
      child: PageView(
        controller: _pageViewController,
        onPageChanged: (newPage) {
          setState(() {
            var db = Provider.of<ExpensesRepository>(context);
            currentPage = newPage;
            _query = db.queryMonth(currentPage + 1);
          });
        },
        children: [
          _pageItem('JANEIRO', 0),
          _pageItem('FEVEREIRO', 1),
          _pageItem('MARÇO', 2),
          _pageItem('ABRIL', 3),
          _pageItem('MAIO', 4),
          _pageItem('JUNHO', 5),
          _pageItem('JULHO', 6),
          _pageItem('AGOSTO', 7),
          _pageItem('SETEMBRO', 8),
          _pageItem('OUTUBRO', 9),
          _pageItem('NOVEMBRO', 10),
          _pageItem('DEZEMBRO', 11),
        ],
      ),
    );
  }

  //Criando notificações

  void setupNotificationPlugin() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin
        .initialize(initializationSettings,
            onSelectNotification: selectNotification)
        .then((init) {
      setupNotification();
    });
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Minhas Finanças'),
        content: Text('Não esqueça de adicionar suas despesas '),
        actions: [
          FlatButton(
            child: Text('Ok, entendi.'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  void setupNotification() async {
    var time = Time(23, 0, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'daily-notification', 'Daily Notification', 'Daily Notification');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Minhas Finanças',
        'Não esqueça de adicionar suas despesas',
        time,
        platformChannelSpecifics);
  }
}
