import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pennywise/models/income.dart';
import 'package:pennywise/services/database.dart';

class AddIncome extends StatefulWidget {
  const AddIncome({super.key});

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  bool isLoading = true;
  List<String> sources = [];

  String? selectedValue;
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  TextEditingController amountController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  dynamic getData() async {
    setState(() {
      sources = [];
      isLoading = true;
    });

    await Database()
        .getSources(FirebaseAuth.instance.currentUser?.uid)
        .then((res) async {
      await Future.delayed(
        const Duration(seconds: 1),
      );
      setState(() {
        sources = res;
        isLoading = false;
      });
    });
  }

  dynamic success(BuildContext context) async {
    context.go("/success", extra: "assets/income.json");
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Add Income"),
        centerTitle: true,
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
          : Center(
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Lottie.asset(
                        "assets/income_static.json",
                        repeat: false,
                      ),
                      const Gap(10),
                      TextFormField(
                        controller: amountController,
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
                            border: OutlineInputBorder(), labelText: "Amount"),
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
                        items: sources
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
                        },
                        onSaved: (value) {
                          selectedValue = value.toString();
                        },
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              TextEditingController src =
                                  TextEditingController();
                              await showDialog<void>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Stack(
                                      clipBehavior: Clip.none,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 0,
                                          ),
                                          child: Form(
                                            key: _formKey1,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: TextFormField(
                                                    validator: (val) {
                                                      if (val == null) {
                                                        return "Cannot inserty empty values";
                                                      }
                                                      if (val.isEmpty) {
                                                        return "Cannot inserty empty values";
                                                      }
                                                      if (val.trim().isEmpty) {
                                                        return "Cannot inserty empty values";
                                                      }
                                                      return null;
                                                    },
                                                    controller: src,
                                                    decoration:
                                                        const InputDecoration(
                                                      label: Text(
                                                          "Source of Income"),
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.text,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextButton(
                                                      child: const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                              CupertinoIcons
                                                                  .xmark_circle,
                                                              color: CupertinoColors
                                                                  .destructiveRed),
                                                          Gap(3),
                                                          Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color: CupertinoColors
                                                                    .destructiveRed),
                                                          ),
                                                        ],
                                                      ),
                                                      onPressed: () {
                                                        context.pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(CupertinoIcons
                                                              .add_circled),
                                                          Gap(3),
                                                          Text('Add'),
                                                        ],
                                                      ),
                                                      onPressed: () {
                                                        if (_formKey1
                                                            .currentState!
                                                            .validate()) {
                                                          _formKey1
                                                              .currentState!
                                                              .save();
                                                          Database().addSources(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                ?.uid,
                                                            src.text,
                                                            getData(),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Row(
                              children: [
                                Icon(CupertinoIcons.add_circled_solid),
                                Gap(3),
                                Text("Add source of income"),
                              ],
                            )),
                      ),
                      const Gap(10),
                      CupertinoButton.filled(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            IncomeModel incomeModel = IncomeModel(
                              amount: double.parse(
                                  amountController.text.replaceAll(',', '')),
                              source: "$selectedValue",
                              id: DateTime.now().millisecondsSinceEpoch,
                            );
                            await Database().addIncome(
                              incomeModel,
                              FirebaseAuth.instance.currentUser?.uid,
                            );
                            // ignore: use_build_context_synchronously
                            success(context);
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.add),
                            Gap(3),
                            Text('Add'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
