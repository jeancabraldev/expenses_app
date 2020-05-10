import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses/utils/colors.dart';
import 'package:flutter/material.dart';

class DayExpenseTile extends StatelessWidget {
  const DayExpenseTile({
    Key key,
    @required this.document,
  }) : super(key: key);

  final DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Icon(
            Icons.calendar_today,
            size: 40,
            color: ColorsLayout.categoryColorCards(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 8,
            child: Text(
              document['day'].toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      title: Container(
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.3),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            'R\$ ${document['value']}',
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
      ),
    );
  }
}