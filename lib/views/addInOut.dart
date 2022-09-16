import 'package:flutter/material.dart';
import 'package:personal_financial/firebase_options.dart';
import 'package:personal_financial/data_repository.dart';
import 'package:personal_financial/models/income.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_financial/views/add_income.dart';

class AddInOut extends StatefulWidget {
  const AddInOut({Key? key}) : super(key: key);

  @override
  State<AddInOut> createState() => _AddInOutState();
}

class _AddInOutState extends State<AddInOut>
    with SingleTickerProviderStateMixin {
  bool choose = true;
  bool newCategory = false;
  TabController? controller;
  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
  }

  TextEditingController categoryController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ))
        ]),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: TabBar(
            controller: controller,
            physics: const BouncingScrollPhysics(),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 3.0, color: Colors.blueAccent),
                insets: EdgeInsets.symmetric(horizontal: 40.0)),
            tabs: const [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Income',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Outcome',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        children: [AddIncome(onSubmit: (String value) {  },), AddIncome(onSubmit: (String value) {  },)],
      ),
    );
  }
}
