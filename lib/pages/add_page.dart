import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/category_selection_widget.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String category;
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Categorias',
          style: TextStyle(color: Colors.purple[900]),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.purple[900],
            ),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        _categorySelector(),
        _currentValue(),
        _numPad(),
        _submit()
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
          'Eletrônicos': Icons.phonelink,
          'Transporte': Icons.directions_bus,
          'Bares': Icons.local_bar,
          'Combustível': Icons.local_gas_station,
          'Lava Rápido': Icons.local_car_wash,
          'Cinema': Icons.local_movies,
          'Hospital': Icons.local_hospital,
          'Farmácia': Icons.local_pharmacy,
          'Taxi': Icons.local_taxi
        },
        //Mostrando a categoria selecionada
        onValueChanged: (newCategory) => category = newCategory,
      ),
    );
  }

  Widget _currentValue() {
    var realValue = value / 100.0;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Text('R\$ ${realValue.toStringAsFixed(2)}',
          style: TextStyle(
              fontSize: 48, fontWeight: FontWeight.w500, color: Colors.purple)),
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
                  value = value ~/ 10;
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
    return Builder(
      builder: (BuildContext context) {
        return Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.purple[900]),
          child: MaterialButton(
            child: Text(
              'Adicionar despesa',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              //Salvando valores
              if (value > 0 && category != null) {
                Firestore.instance.collection('expenses').document().setData({
                  'category': category,
                  'value': value,
                  'month': DateTime.now().month,
                  'day': DateTime.now().day,
                });
                Navigator.of(context).pop();
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Selecione uma categoria e informe um valor'),
                ));
              }
            },
          ),
        );
      },
    );
  }
}
