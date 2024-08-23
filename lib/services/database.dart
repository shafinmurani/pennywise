import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pennywise/models/expense.dart';
import 'package:pennywise/models/income.dart';

class Database {
  //income
  Future<List<IncomeModel>> getIncome(String? uid) async {
    List<IncomeModel> incomeArray = [];
    await FirebaseFirestore.instance.collection("/user").doc(uid).get().then(
      (val) {
        for (var element in val['income']) {
          IncomeModel income = IncomeModel(
            amount: element['amount'],
            id: element['id'],
            source: element['source'],
          );
          incomeArray.add(income);
        }
      },
    );

    return incomeArray.reversed.toList();
  }

  Future<List<String>> getSources(String? uid) async {
    List<String> sourceArray = [];
    await FirebaseFirestore.instance.collection("/user").doc(uid).get().then(
      (val) {
        for (var element in val['sources']) {
          sourceArray.add(element);
        }
      },
    );
    return sourceArray;
  }

  void addSources(String? uid, String source, dynamic callback) async {
    var collection = FirebaseFirestore.instance.collection('/user');
    await collection.doc(uid).update({
      "sources": FieldValue.arrayUnion([source])
    });
    callback();
  }

  addIncome(IncomeModel income, String? uid) async {
    var collection = FirebaseFirestore.instance.collection('/user');
    await collection.doc(uid).update({
      "income": FieldValue.arrayUnion([income.toJson()])
    });
  }

  deleteIncome(IncomeModel income, String? uid) async {
    var collection = FirebaseFirestore.instance.collection('/user');
    await collection.doc(uid).update({
      "income": FieldValue.arrayRemove([income.toJson()])
    });
  }

  //expenses
  addExpense(ExpenseModel expense, String? uid) {}
  deleteExpense(ExpenseModel expense, String? uid) {}
}
