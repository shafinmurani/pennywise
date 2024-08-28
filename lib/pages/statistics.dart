import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pennywise/models/expense.dart';
import 'package:pennywise/models/income.dart';
import 'package:pennywise/services/database.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  List<IncomeModel> incomeArray = [];
  List<ExpenseModel> expenseArray = [];
  bool loadingIncome = true;
  bool loadingExpense = true;
  double averageIncomePerDay = 0.0;
  double averageExpensePerDay = 0.0;

  @override
  void initState() {
    super.initState();
    getIncomeData();
    getExpenseData();
  }

  void getIncomeData() {
    Database()
        .getIncome(FirebaseAuth.instance.currentUser?.uid)
        .then((res) async {
      setState(() {
        incomeArray = res;
        loadingIncome = false;
        calculateAverageIncomePerDay();
      });
    });
  }

  void getExpenseData() {
    Database()
        .getExpense(FirebaseAuth.instance.currentUser?.uid)
        .then((res) async {
      setState(() {
        expenseArray = res;
        loadingExpense = false;
        calculateAverageExpensePerDay();
      });
    });
  }

  void calculateAverageIncomePerDay() {
    if (incomeArray.isEmpty) return;

    DateTime startDate = incomeArray
        .map((i) => i.dateTime!)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    DateTime endDate = DateTime.now();

    int days = endDate.difference(startDate).inDays + 1;
    double totalIncome =
        incomeArray.fold(0, (sum, income) => sum + income.amount);

    setState(() {
      averageIncomePerDay = totalIncome / days;
    });
  }

  void calculateAverageExpensePerDay() {
    if (expenseArray.isEmpty) return;

    DateTime startDate = expenseArray
        .map((e) => e.dateTime!)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    DateTime endDate = DateTime.now();

    int days = endDate.difference(startDate).inDays + 1;
    double totalExpense =
        expenseArray.fold(0, (sum, expense) => sum + expense.amount);

    setState(() {
      averageExpensePerDay = totalExpense / days;
    });
  }

  List<PieChartSectionData> getMonthlyIncomeSections() {
    double totalIncome =
        incomeArray.fold(0, (sum, income) => sum + income.amount);

    Map<String, double> monthlyIncome = {};
    for (var income in incomeArray) {
      String category = income.source; // Corrected to 'source'
      if (monthlyIncome.containsKey(category)) {
        monthlyIncome[category] = monthlyIncome[category]! + income.amount;
      } else {
        monthlyIncome[category] = income.amount;
      }
    }

    return monthlyIncome.entries.map((entry) {
      double percentage = (entry.value / totalIncome) * 100;
      return PieChartSectionData(
        value: entry.value,
        title: '${entry.key}\n${percentage.toStringAsFixed(1)}%',
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Colors.primaries[monthlyIncome.keys.toList().indexOf(entry.key) %
            Colors.primaries.length],
        radius: 100,
      );
    }).toList();
  }

  List<PieChartSectionData> getMonthlyExpenseSections() {
    double totalExpense =
        expenseArray.fold(0, (sum, expense) => sum + expense.amount);

    Map<String, double> monthlyExpenses = {};
    for (var expense in expenseArray) {
      String category = expense.topic; // Assuming `topic` is the category
      if (monthlyExpenses.containsKey(category)) {
        monthlyExpenses[category] = monthlyExpenses[category]! + expense.amount;
      } else {
        monthlyExpenses[category] = expense.amount;
      }
    }

    return monthlyExpenses.entries.map((entry) {
      double percentage = (entry.value / totalExpense) * 100;
      return PieChartSectionData(
        value: entry.value,
        title: '${entry.key}\n${percentage.toStringAsFixed(1)}%',
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Colors.primaries[
            monthlyExpenses.keys.toList().indexOf(entry.key) %
                Colors.primaries.length],
        radius: 100,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return loadingIncome || loadingExpense
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Average Income and Expense with Divider
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Average Income Per Day: ₹${averageIncomePerDay.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        width: 20,
                        color: Colors.black,
                        thickness: 2,
                      ),
                      Expanded(
                        child: Text(
                          'Average Expense Per Day: ₹${averageExpensePerDay.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Income Pie Chart
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Income Breakdown',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        centerSpaceRadius: 30,
                        sectionsSpace: 2,
                        sections: getMonthlyIncomeSections(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Expense Pie Chart
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Expense Breakdown',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        centerSpaceRadius: 30,
                        sectionsSpace: 2,
                        sections: getMonthlyExpenseSections(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
