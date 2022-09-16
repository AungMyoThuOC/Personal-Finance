import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:personal_financial/data_repository.dart';
import 'package:personal_financial/views/saving_dash.dart';

import 'Components/home_history.dart';
import 'Components/pie_chart.dart';
import 'Components/table.dart';
import 'models/income.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);
  // final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool choose = true;
  double size = 250;
  bool sizeCheck = true;
  ScrollMetrics? metrics;
  bool bottomNavigator = true;
  TabController? controller;

  final List<String> items = [
    'Income',
    'Outcome',
  ];

  String selectedValue = 'Income';
  final DataRepository repository = DataRepository();

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    controller!.addListener(() {
      setState(() {
        if (controller!.index == 0) {
          bottomNavigator = true;
        }
        if (controller!.index == 1) {
          bottomNavigator = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.wallet,
                    color: Colors.black,
                    size: 30,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/setting');
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.black,
                      ))
                ]),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: TabBar(
                controller: controller,
                physics: const BouncingScrollPhysics(),
                onTap: (value) {
                  setState(() {
                    if (bottomNavigator == true) {
                      bottomNavigator = false;
                      if (value == 0) {
                        bottomNavigator = true;
                      } else {
                        bottomNavigator = false;
                      }
                    }
                    if (bottomNavigator == false) {
                      bottomNavigator = true;
                      if (value == 1) {
                        bottomNavigator = false;
                      } else {
                        bottomNavigator = true;
                      }
                    }
                  });
                },
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: const UnderlineTabIndicator(
                    borderSide:
                        BorderSide(width: 3.0, color: Colors.blueAccent),
                    insets: EdgeInsets.symmetric(horizontal: 40.0)),
                tabs: const [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        'Home',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        'Saving',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: ExpandableBottomSheet(
          background: TabBarView(
              controller: controller,
              physics: const BouncingScrollPhysics(),
              children: [
                Stack(
                  children: [
                    Container(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Container(
                                child: Container(
                              child: Column(
                                children: [
                                  Center(
                                      child: Container(
                                          height: 200,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: PieChart())),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Container(
                                          child: Container(
                                        child: const TableInOutCome(),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Center(
                  child: ViewSaving(),
                )
              ]),
          persistentContentHeight: 220,
          persistentHeader: (bottomNavigator == true)
              ? Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      )),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Positioned(
                            right: 10,
                            child: SizedBox(
                              width: 40,
                              child: FloatingActionButton(
                                  elevation: 0,
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/add');
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.horizontal_rule_rounded,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : null,
          expandableContent: (bottomNavigator == true)
              ? Container(
                  color: Colors.white,
                  constraints: BoxConstraints(maxHeight: 500),
                  height: 500,
                  child: Container(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: StreamBuilder<QuerySnapshot>(
                              stream: repository.getAddStream(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return LinearProgressIndicator();

                                return _buildList(
                                    context, snapshot.data?.docs ?? []);
                              }),
                        )),
                  ),
                )
              : Container(),
        ),
      ),
    );
  }
}

class ChartData {
  final String x;
  final double y;
  final String size;
  ChartData(this.x, this.y, this.size);
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return Column(
    children: [
      Expanded(
        child: ListView(
          addAutomaticKeepAlives: true,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          shrinkWrap: true,
          children:
              snapshot.map((data) => _buildListItem(context, data)).toList(),
        ),
      ),
    ],
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
  final income = Income.fromSnapshot(snapshot);
  return HomeHistory(income: income);
}
