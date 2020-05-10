import 'package:cloud_firestore/cloud_firestore.dart';

class ExpensesRepository {
  final String userId;

  ExpensesRepository(this.userId);

  Stream<QuerySnapshot> queryCategory(int month, String categoryName) {
    return Firestore.instance
        .collection('users')
        .document(userId)
        .collection('expenses')
        .where("month", isEqualTo: month)
        .where("category", isEqualTo: categoryName)
        .snapshots();
  }

  Stream<QuerySnapshot> queryMonth(int month) {
    return Firestore.instance
        .collection('users')
        .document(userId)
        .collection('expenses')
        .where("month", isEqualTo: month)
        .snapshots();
  }

  addExpense(String categoryName, int value, DateTime date) {
    Firestore.instance
        .collection('users')
        .document(userId)
        .collection('expenses')
        .document()
        .setData({
      'category': categoryName,
      'value': value / 100,
      'month': date.month,
      'day': date.day,
      'year': date.year,
    });
  }

  deleteExpense(String documentId) {
    Firestore.instance
        .collection('users')
        .document(userId)
        .collection('expenses')
        .document(documentId)
        .delete();
  }
}
