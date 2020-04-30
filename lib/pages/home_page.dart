import 'dart:ui';
import 'package:rect_getter/rect_getter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses/states/login_state.dart';
import 'package:expenses/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../widgets/month.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var globalKey = RectGetter.createGlobalKey();
  Rect buttonRect;

  //Controllers
  PageController _pageViewController;

  int currentPage = DateTime.now().month -1;
  bool bottomBar = true;

  Stream<QuerySnapshot> _query;

  @override
  void initState() {
    super.initState();

    _pageViewController =
        PageController(initialPage: currentPage, viewportFraction: 0.4);
  }

  //Criando botões
  Widget _bottomAction(IconData icon, Function callback) {
    return InkWell(
      child: Icon(icon, color: Color.fromRGBO(75, 0, 130, 1), size: 28),
      onTap: callback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
      builder: (BuildContext context, LoginState state, Widget child) {
        var user = Provider.of<LoginState>(context).currentUser();
        _query = Firestore.instance
            .collection('users')
            .document(user.uid)
            .collection('expenses')
            .where("month", isEqualTo: currentPage + 1)
            .snapshots();

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
                  _bottomAction(FontAwesomeIcons.chartLine, (){}),
                  _bottomAction(Icons.pie_chart, (){}),
                  SizedBox(
                    width: 50,
                  ),
                  _bottomAction(Icons.account_balance_wallet, (){}),
                  _bottomAction(FontAwesomeIcons.signOutAlt, (){
                    Provider.of<LoginState>(context).logout();
                  })
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: RectGetter(
            key: globalKey,
            child: FloatingActionButton(
              backgroundColor: Color.fromRGBO(9, 31, 146, 1),
              child: Icon(Icons.add),
              onPressed: () {
                buttonRect = RectGetter.getRectFromKey(globalKey);
                print(buttonRect);
                Navigator.of(context).pushNamed('/add', arguments: buttonRect);
              },
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _query,
                  builder:
                      (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
                    //Verificando se tem dados
                    if (data.hasData) {
                      return Month(
                        days: daysInMonth(currentPage + 1),
                          documents: data.data.documents);
                    }
                    return Container(
                      height: MediaQuery.of(context).size.height - 154,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                  height: 70,
                  color: Colors.black26.withOpacity(.03),
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
    final selected = TextStyle(
        color: Color.fromRGBO(75, 0, 130, 1), fontSize: 18, fontWeight: FontWeight.bold);
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
            var user = Provider.of<LoginState>(context).currentUser();
            currentPage = newPage;
            _query = Firestore.instance
                .collection('users')
                .document(user.uid)
                .collection('expenses')
                .where("month", isEqualTo: currentPage + 1)
                .snapshots();
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
}
