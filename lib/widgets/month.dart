import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/graph.dart';

class Month extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perDay;
  final Map<String, double> categories;

  Month({Key key, this.documents, days})
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
          Container(
            color: Colors.black.withOpacity(.1),
            height: 10,
          ),
          _list(),
        ],
      ),
    );
  }

  //Configurando total de gastos
  Widget _expenses() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        children: [
          Text(
            'R\$ ${widget.total.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            'Total despesas',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  //Gráfico
  Widget _graph() {
    return Container(
      height: 160,
      child: Graph(data: widget.perDay),
    );
  }

  //Itens da lista
  Widget _item(IconData icon, String name, int percent, double value) {
    return ListTile(
      leading: Icon(
        icon,
        size: 32,
      ),
      title: Text(
        name,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        '$percent% das despesas',
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromRGBO(67, 97, 238, 0.2),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
          child: Text(
            'R\$ $value',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  //Lista de despesas
  Widget _list() {
    return Expanded(
        child: ListView.separated(
      itemCount: widget.categories.keys.length,
      itemBuilder: (BuildContext context, index) {
        var key = widget.categories.keys.elementAt(index);
        var data = widget.categories[key];
        return _item(
            Icons.shopping_cart, key, 100 * data ~/ widget.total, data);
      },
      separatorBuilder: (BuildContext context, index) {
        return Container(
          color: Colors.black.withOpacity(.1),
          height: 2,
        );
      },
    ));
  }
}
