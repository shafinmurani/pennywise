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
            dateTime: DateTime.fromMillisecondsSinceEpoch(element['id']),
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

  editIncome(IncomeModel income, IncomeModel newIncome, String? uid) async {
    await FirebaseFirestore.instance
        .collection('/user')
        .doc(uid)
        .get()
        .then((value) async {
      List array = value['income'];
      //Finding the index to modify
      var indexToModify =
          array.indexWhere((element) => element['id'] == income.id);
      //Modifying the current entry
      array[indexToModify] = newIncome.toJson();
      // Sending the data back to firebase
      await FirebaseFirestore.instance
          .collection('/user')
          .doc(uid)
          .update({"income": array});
    });
  }

  //expenses
  Future<List<ExpenseModel>> getExpense(String? uid) async {
    List<ExpenseModel> expenseArray = [];
    await FirebaseFirestore.instance.collection("/user").doc(uid).get().then(
      (val) {
        for (var element in val['expenses']) {
          ExpenseModel expense = ExpenseModel(
            amount: element['amount'],
            id: element['id'],
            topic: element['topic'],
            dateTime: DateTime.fromMillisecondsSinceEpoch(element['id']),
          );
          expenseArray.add(expense);
        }
      },
    );

    return expenseArray.reversed.toList();
  }

  Future<List<String>> getTopics(String? uid) async {
    List<String> sourceArray = [];
    await FirebaseFirestore.instance.collection("/user").doc(uid).get().then(
      (val) {
        for (var element in val['topics']) {
          sourceArray.add(element);
        }
      },
    );
    return sourceArray;
  }

  void addTopics(String? uid, String source, dynamic callback) async {
    var collection = FirebaseFirestore.instance.collection('/user');
    await collection.doc(uid).update({
      "topics": FieldValue.arrayUnion([source])
    });
    callback();
  }

  addExpense(ExpenseModel expense, String? uid) async {
    var collection = FirebaseFirestore.instance.collection('/user');
    await collection.doc(uid).update({
      "expenses": FieldValue.arrayUnion([expense.toJson()])
    });
  }

  deleteExpense(ExpenseModel expense, String? uid) async {
    var collection = FirebaseFirestore.instance.collection('/user');
    await collection.doc(uid).update({
      "expenses": FieldValue.arrayRemove([expense.toJson()])
    });
  }

  editExpense(
      ExpenseModel expense, ExpenseModel newExpense, String? uid) async {
    await FirebaseFirestore.instance
        .collection('/user')
        .doc(uid)
        .get()
        .then((value) async {
      List array = value['expenses'];
      //Finding the index to modify
      var indexToModify =
          array.indexWhere((element) => element['id'] == expense.id);
      //Modifying the current entry
      array[indexToModify] = newExpense.toJson();
      // Sending the data back to firebase
      await FirebaseFirestore.instance
          .collection('/user')
          .doc(uid)
          .update({"expenses": array});
    });
  }
}
