import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses/states/login_state.dart';
import 'package:expenses/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../widgets/category_selection_widget.dart';

class AddPage extends StatefulWidget {
  final Rect buttonRect;

  const AddPage({Key key, this.buttonRect}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _buttonAnimation;
  Animation _pageAnimation;
  String category;
  int value = 0;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750));

    _buttonAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController, curve: Curves.fastOutSlowIn));

    _pageAnimation = Tween<double>(begin: -1, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));

    _animationController.addListener(() {
      setState(() {});
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        Navigator.of(context).pop();
      }
    });

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: Offset(0, height * (1 - _pageAnimation.value)),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                '',
                style: TextStyle(
                    color: Color.fromRGBO(30, 150, 252, 1), fontSize: 22),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: ColorsLayout.primaryTextColor(),
                  ),
                  onPressed: () => _animationController.reverse(),
                )
              ],
            ),
            body: _body(),
          ),
        ),
        _submit()
      ],
    );
  }

  Widget _body() {
    var height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        _categorySelector(),
        _currentValue(),
        _numPad(),
        SizedBox(
          height: height - widget.buttonRect.top,
        ),
      ],
    );
  }

  Widget _categorySelector() {
    return Container(
      height: 80,
      child: CategorySelectionWidget(
        categories: {
          'Games': Icons.games,
          'Shopping': Icons.shopping_cart,
          'Restaurantes': Icons.restaurant,
          'Pizzaria': Icons.local_pizza,
          'Bebidas': FontAwesomeIcons.beer,
          'Fast Food': Icons.fastfood,
          'Contas': Icons.account_balance_wallet,
          'Viagens': Icons.airplanemode_active,
          'Eletronicos': Icons.phonelink,
          'Transporte': Icons.directions_bus,
          'Bares': Icons.local_bar,
          'Combustível': Icons.local_gas_station,
          'Lava Rápido': Icons.local_car_wash,
          'Cinema': Icons.local_movies,
          'Hospital': Icons.local_hospital,
          'Farmácia': Icons.local_pharmacy,
          'Taxi': Icons.local_taxi,
          'Conveniência': Icons.local_convenience_store
        },
        //Mostrando a categoria selecionada
        onValueChanged: (newCategory) => category = newCategory,
      ),
    );
  }

  Widget _currentValue() {
    var realValue = value / 100;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Text('R\$ ${realValue.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w500,
            color: ColorsLayout.primaryTextColor(),
          )),
    );
  }

  //Configurando espaçamento e toques do teclado
  Widget _num(String text, double height) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          if (text == ',') {
            value = value * 100;
          } else {
            value = value * 10 + int.parse(text);
          }
        });
      },
      child: Container(
          height: height,
          child: Center(
            child:
                Text(text, style: TextStyle(fontSize: 40, color: Colors.grey)),
          )),
    );
  }

  //Configurando base do teclado numerico
  Widget _numPad() {
    return Expanded(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var height = constraints.biggest.height / 4;
      return Table(
        border: TableBorder.all(
          color: Colors.grey,
          width: 1,
        ),
        children: [
          TableRow(children: [
            _num('1', height),
            _num('2', height),
            _num('3', height),
          ]),
          TableRow(children: [
            _num('4', height),
            _num('5', height),
            _num('6', height),
          ]),
          TableRow(children: [
            _num('7', height),
            _num('8', height),
            _num('9', height),
          ]),
          TableRow(children: [
            _num(',', height),
            _num('0', height),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  value = value ~/ 10 + (value - value.toInt());
                });
              },
              child: Container(
                height: height,
                child: Center(
                  child: Icon(Icons.backspace, color: Colors.grey, size: 28),
                ),
              ),
            ),
          ])
        ],
      );
    }));
  }

  Widget _submit() {
    if (_animationController.value < 1) {
      var buttonWidth = widget.buttonRect.right - widget.buttonRect.left;
      var width = MediaQuery.of(context).size.width;
      return Positioned(
        top: widget.buttonRect.top,
        left: widget.buttonRect.left * (1 - _buttonAnimation.value),
        right: (width - widget.buttonRect.right) * (1 - _buttonAnimation.value),
        bottom:
            (MediaQuery.of(context).size.height - widget.buttonRect.bottom) *
                (1 - _buttonAnimation.value),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  buttonWidth * (1 - _buttonAnimation.value)),
              color: ColorsLayout.primaryColor()),
        ),
      );
    } else {
      return Positioned(
        top: widget.buttonRect.top,
        bottom: 0,
        left: 0,
        right: 0,
        child: Builder(
          builder: (BuildContext context) {
            return Container(
//            height: widget.buttonRect.top,
//            width: double.infinity,
              decoration: BoxDecoration(color: ColorsLayout.primaryColor()),
              child: MaterialButton(
                child: Text(
                  'Adicionar despesa',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  var today = DateTime.now();
                  var user = Provider.of<LoginState>(context).currentUser();
                  //Salvando valores
                  if (value > 0 && category != null) {
                    Firestore.instance
                        .collection('users')
                        .document(user.uid)
                        .collection('expenses')
                        .document()
                        .setData({
                      'category': category,
                      'value': value / 100,
                      'month': today.month,
                      'day': today.day,
                      'year': today.year,
                    });
                    Navigator.of(context).pop();
                  } else {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(
                                'Minhas Finanças',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              content: Text(
                                  'Para adicionar uma despesa é necessário '
                                  'selecionar uma categoria e informar '
                                  'um valor.'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('ok, entendi.',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: ColorsLayout.primaryColor(),
                                          fontWeight: FontWeight.w600)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ));
                  }
                },
              ),
            );
          },
        ),
      );
    }
  }
}
