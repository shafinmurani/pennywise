import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pennywise/models/expense.dart';
import 'package:pennywise/models/income.dart';

class Database {
  //income
  Future<List<IncomeModel>> getIncome(String? uid) async {
    List<IncomeModel> incomeArray = [];
    FirebaseFirestore.instance.collection("/user").doc(uid).get().then(
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
    return incomeArray;
  }

  addIncome(IncomeModel income, String? uid) {}
  deleteIncome(IncomeModel income, String? uid) {}

  //expenses
  addExpense(ExpenseModel expense, String? uid) {}
  deleteExpense(ExpenseModel expense, String? uid) {}
}
