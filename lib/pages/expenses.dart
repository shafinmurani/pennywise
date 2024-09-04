import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pennywise/models/expense.dart';
import 'package:pennywise/services/database.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  Future<void> showEditExpenseDialog({required ExpenseModel expense}) async {
    List<String> topics = [];

    dynamic getDataTopics() async {
      setState(() {
        topics = [];
        isLoading = true;
      });

      await Database()
          .getTopics(FirebaseAuth.instance.currentUser?.uid)
          .then((res) async {
        setState(() {
          topics = res;
          isLoading = false;
        });
      });
    }

    await getDataTopics();
    String selectedValue =
        topics.firstWhere((element) => element == expense.topic);
    TextEditingController amtController =
        TextEditingController(text: expense.amount.toString());
    return showDialog<void>(
      // ignore: use_build_context_synchronously
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        final formKey = GlobalKey<FormState>();
        return AlertDialog(
          title: const Text('Edit Income'),
          content: isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/loading.json", height: 120),
                      const Gap(10),
                      const Text("Loading..."),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: ListBody(
                      children: <Widget>[
                        TextFormField(
                          controller: amtController,
                          validator: (value) {
                            if (value == null) {
                              return "Please input a valid amount";
                            }
                            if (value.isEmpty) {
                              return "Please input a valid amount";
                            }
                            if (double.parse(value.replaceAll(",", ""))
                                .isNegative) {
                              return "Please input a valid amount";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Amount",
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: false,
                            decimal: true,
                          ),
                        ),
                        const Gap(10),
                        DropdownButtonFormField2<String>(
                          // isExpanded: true,
                          decoration: InputDecoration(
                            // Add Horizontal padding using menuItemStyleData.padding so it matches
                            // the menu padding when button's width is not specified.
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // Add more decoration..
                          ),
                          hint: const Text(
                            'Source of Income',
                            style: TextStyle(fontSize: 14),
                          ),
                          items: topics
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select your source of income';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            //Do something when selected item is changed.
                            selectedValue = value.toString();
                          },
                          onSaved: (value) {
                            selectedValue = value.toString();
                          },
                          value: selectedValue,
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 24,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () async {
                Navigator.of(context).pop();
                ExpenseModel newExpense = ExpenseModel(
                  amount: double.parse(amtController.text.replaceAll(',', '')),
                  topic: selectedValue,
                  id: expense.id,
                );
                await Database().editExpense(expense, newExpense,
                    FirebaseAuth.instance.currentUser?.uid);
                setState(() {
                  expenseArray = [];
                  isLoading = true;
                });
                Database()
                    .getExpense(FirebaseAuth.instance.currentUser?.uid)
                    .then((res) async {
                  await Future.delayed(const Duration(seconds: 1));
                  setState(() {
                    expenseArray = res;
                    isLoading = false;
                  });
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showExpenseDialog({required ExpenseModel expense}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        DateTime time = DateTime.fromMillisecondsSinceEpoch(expense.id);
        return AlertDialog(
          scrollable: true,
          title: const Text('Modify Expense?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  title: Text("Topic: ${expense.topic}"),
                  subtitle: Text(DateFormat.yMd().add_jm().format(time)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "-",
                        style: TextStyle(
                          color: CupertinoColors.systemRed,
                        ),
                      ),
                      const Icon(
                        Icons.currency_rupee_rounded,
                        size: 12,
                        color: CupertinoColors.systemRed,
                      ),
                      const Gap(1),
                      Text(
                        expense.amount.toString(),
                        style: const TextStyle(
                          color: CupertinoColors.systemRed,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    showEditExpenseDialog(expense: expense);
                  },
                  leading: const Icon(CupertinoIcons.pen),
                  title: const Text("Edit Expense"),
                ),
                ListTile(
                  onTap: () async {
                    Navigator.of(context).pop();
                    Database().deleteExpense(
                      expense,
                      FirebaseAuth.instance.currentUser?.uid,
                    );
                    setState(() {
                      isLoading = true;
                      expenseArray = [];
                    });
                    await Database()
                        .getExpense(FirebaseAuth.instance.currentUser?.uid)
                        .then((res) async {
                      // await Future.delayed(const Duration(seconds: 1));
                      setState(() {
                        expenseArray = res;
                        isLoading = false;
                      });
                    });
                  },
                  leading: const Icon(CupertinoIcons.trash),
                  title: const Text("Delete Expense"),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<ExpenseModel> expenseArray = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Database()
        .getExpense(FirebaseAuth.instance.currentUser?.uid)
        .then((res) async {
      // await Future.delayed(const Duration(seconds: 1));
      setState(() {
        expenseArray = res;
        isLoading = false;
      });
    });
  }

  bool _showFab = true;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 300);
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          isLoading = true;
          expenseArray = [];
        });
        await Database()
            .getExpense(FirebaseAuth.instance.currentUser?.uid)
            .then((res) async {
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            expenseArray = res;
            isLoading = false;
          });
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Information",
                style: GoogleFonts.robotoMono(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Amount",
                style: GoogleFonts.robotoMono(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        body: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset("assets/loading.json", height: 120),
                    const Gap(10),
                    const Text("Loading..."),
                  ],
                ),
              )
            : expenseArray.isEmpty
                ? const Center(child: Text("No data available."))
                : NotificationListener<UserScrollNotification>(
                    onNotification: (notification) {
                      final ScrollDirection direction = notification.direction;
                      setState(
                        () {
                          if (direction == ScrollDirection.reverse) {
                            _showFab = false;
                          } else if (direction == ScrollDirection.forward) {
                            _showFab = true;
                          }
                        },
                      );
                      return true;
                    },
                    child: ListView.builder(
                      itemCount: expenseArray.length,
                      itemBuilder: (context, index) {
                        DateTime time = DateTime.fromMillisecondsSinceEpoch(
                            expenseArray[index].id);

                        return ListTile(
                          onTap: () {
                            showExpenseDialog(expense: expenseArray[index]);
                          },
                          title: Text("Topic: ${expenseArray[index].topic}"),
                          subtitle: Text(
                              "Date: ${DateFormat.yMd().add_jm().format(time)}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "-",
                                style: TextStyle(
                                  color: CupertinoColors.systemRed,
                                ),
                              ),
                              const Icon(
                                Icons.currency_rupee_rounded,
                                size: 12,
                                color: CupertinoColors.systemRed,
                              ),
                              const Gap(1),
                              Text(
                                expenseArray[index].amount.toString(),
                                style: const TextStyle(
                                  color: CupertinoColors.systemRed,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
        floatingActionButton: AnimatedSlide(
          duration: duration,
          offset: _showFab ? Offset.zero : const Offset(0, 2),
          child: AnimatedOpacity(
            duration: duration,
            opacity: _showFab ? 1 : 0,
            child: FloatingActionButton(
              backgroundColor: const Color(0xffe4e4e4),
              foregroundColor: const Color(0xff1e1e1e),
              onPressed: () {
                context.push("/expense/add");
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
