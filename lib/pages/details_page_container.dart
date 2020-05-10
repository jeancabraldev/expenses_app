import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses/repository/expenses_repository.dart';
import 'package:expenses/states/login_state.dart';
import 'package:expenses/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/day_expense_tile.dart';
import 'details_page.dart';

class DetailsParams {
  final String categoryName;
  final int month;

  DetailsParams(this.categoryName, this.month);
}

class DetailsPageContainer extends StatefulWidget {
  final DetailsParams params;

  const DetailsPageContainer({Key key, this.params}) : super(key: key);

  @override
  _DetailsPageContainerState createState() => _DetailsPageContainerState();
}

class _DetailsPageContainerState extends State<DetailsPageContainer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesRepository>(
      builder: (BuildContext context, ExpensesRepository db, Widget child) {
        var user = Provider.of<LoginState>(context).currentUser();
        var db = ExpensesRepository(user.uid);
        var _query = db.queryCategory(
            widget.params.month + 1, widget.params.categoryName);

        return StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
              if(data.hasData){
                return DetailsPage(
                  categoryName: widget.params.categoryName,
                  documents: data.data.documents,
                  onDelete: (documentId) {
                    db.deleteExpense(documentId);
                  },
                );
              } else{
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: ColorsLayout.categoryColorCards(),
                  ),
                );
              }

            });
      },
    );
  }
}
