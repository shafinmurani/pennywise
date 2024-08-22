import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pennywise/models/income.dart';
import 'package:pennywise/services/database.dart';

class Income extends StatefulWidget {
  const Income({super.key});

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  List<IncomeModel> incomeArray = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    Database().getIncome(FirebaseAuth.instance.currentUser?.uid).then((res) {
      setState(() {
        incomeArray = res;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          incomeArray = [];
          isLoading = true;
        });
        await Future.delayed(const Duration(seconds: 1));
        await Database()
            .getIncome(FirebaseAuth.instance.currentUser?.uid)
            .then((res) {
          setState(() {
            incomeArray = res;
            isLoading = false;
          });
        });
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Income",
            style: GoogleFonts.robotoMono(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: isLoading
            ? const Center(
                child: CupertinoActivityIndicator(
                  radius: 14,
                ),
              )
            : incomeArray.isEmpty
                ? const Center(child: Text("No data available."))
                : ListView.builder(
                    itemCount: incomeArray.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(incomeArray[index].source),
                        trailing: Text(incomeArray[index].amount.toString()),
                      );
                    },
                  ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push("/income/add");
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
