import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses/pages/details_page.dart';
import 'package:expenses/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/graph.dart';

enum GraphType { LINES, PIE }

class Month extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perDay;
  final Map<String, double> categories;
  final GraphType graphType;
  final int month;

  Month({Key key, @required this.month, this.graphType, this.documents, days})
      : total = documents.map((doc) => doc['value']).fold(0.0, (a, b) => a + b),
        perDay = List.generate(days, (int index) {
          return documents
              .where((doc) => doc['day'] == (index + 1))
              .map((doc) => doc['value'])
              .fold(0.0, (a, b) => a + b);
        }),
        categories = documents.fold({}, (Map<String, double> map, document) {
          if (!map.containsKey(document['category'])) {
            map[document['category']] = 0.0;
          }
          map[document['category']] += document['value'];
          return map;
        }),
        super(key: key);

  @override
  _MonthState createState() => _MonthState();
}

class _MonthState extends State<Month> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _expenses(),
          _graph(),
//          Container(
//            color: Colors.black.withOpacity(.1),
//            height: 2,
//          ),
          _listCard()
          //_list(),
        ],
      ),
    );
  }

  //Configurando total de gastos
  Widget _expenses() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color.fromRGBO(242, 242, 242, .2),
                Color.fromRGBO(242, 242, 242, .9)
              ]),
          color: Colors.grey),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
      child: Column(
        children: [
          Text(
            'R\$ ${widget.total.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            'Total das despesas',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  //Gráfico
  Widget _graph() {
    if (widget.graphType == GraphType.LINES) {
      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            //color: Color.fromRGBO(242, 242, 242, .4),
          ),
          height: 180,
          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: GraphLine(data: widget.perDay),
        ),
      );
    } else {
      var perCategory = widget.categories.keys
          .map((name) => widget.categories[name] / widget.total);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            //color: Color.fromRGBO(242, 242, 242, .4),
          ),
          height: 180,
          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: GraphPie(data: widget.perDay),
        ),
      );
    }
  }

  Widget _listCard() {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: false,
        itemCount: widget.categories.keys.length,
        itemBuilder: (BuildContext context, int index) {
          var key = widget.categories.keys.elementAt(index);
          var data = widget.categories[key];
          return _cardList(
              FontAwesomeIcons.gift, key, 100 * data ~/ widget.total, data);
        },
      ),
    );
  }

  Widget _cardList(IconData icon, String name, int percent, double value) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/details',
            arguments: DetailsParams(name, widget.month));
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          width: MediaQuery.of(context).size.width - 8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //Icon(icon),
                  Text(
                    name,
                    style: TextStyle(
                        color: ColorsLayout.categoryColorCards(),
                        fontSize: 24,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'R\$ $value',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '$percent% das despesas',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
