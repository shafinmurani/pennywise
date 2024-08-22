import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pennywise/models/expense.dart';
import 'package:pennywise/models/income.dart';

class Database {
  //income
  Future<List<Income>> getIncome(String? uid) async {
    List<Income> incomeArray = [];
    FirebaseFirestore.instance.collection("/user").doc(uid).get().then(
      (val) {
        for (var element in val['income']) {
          Income income = Income(
            amount: element['amount'],
            id: element['id'],
            source: element['source'],
          );
          incomeArray.add(income);
        }
      },
    );
    return incomeArray;
  }

  addIncome(Income income, String? uid) {}
  deleteIncome(Income income, String? uid) {}

  //expenses
  addExpense(Expense expense, String? uid) {}
  deleteExpense(Expense expense, String? uid) {}
}
