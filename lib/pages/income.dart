import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
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
    if (mounted) {
      setState(() {});
    }
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          isLoading = true;
          incomeArray = [];
        });
        await Database()
            .getIncome(FirebaseAuth.instance.currentUser?.uid)
            .then((res) async {
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            incomeArray = res;
            isLoading = false;
          });
        });
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          title: Text(
            "Income",
            style: GoogleFonts.robotoMono(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
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
            : incomeArray.isEmpty
                //TODO : Fix auto array clear bug, can't refresh
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
