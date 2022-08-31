import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_financial/Components/home_history.dart';
import 'package:personal_financial/models/income.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'Components/pie_chart.dart';
import 'Components/table.dart';
import 'firebase_options.dart';
import 'data_repository.dart';
import 'models/income.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'views/saving.dart';
import 'views/saving_details.dart';
import 'views/addInOut.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/add': (context) => const AddInOut(),
        '/saving_details': (context) => const SavingDetails()
      },
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool choose = true;
  double size = 250;
  bool sizeCheck = true;
  ScrollMetrics? metrics;
  bool bottomNavigator = true;
  final PageController controller = PageController();
  final List<String> items = [
    'Income',
    'Outcome',
  ];
  String selectedValue = 'Income';
  final DataRepository repository = DataRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: (bottomNavigator == true)
          ? SizedBox(
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
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: (bottomNavigator == true)
          ? ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
              child: BottomAppBar(
                  color: Colors.blue,
                  shape: const CircularNotchedRectangle(),
                  notchMargin: 5,
                  elevation: 0,
                  child: NotificationListener(
                    onNotification: (ScrollNotification notify) {
                      setState(() {
                        if (notify.metrics.pixels > 30) {
                          size = 400;
                        } else {
                          size = 250;
                        }
                      });
                      return false;
                    },
                    child: Container(
                      height: size,
                      child: Container(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: repository.getStream(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return LinearProgressIndicator();

                                    return _buildList(
                                        context, snapshot.data?.docs ?? []);
                                  }),
                            )),
                      ),
                    ),
                  )),
            )
          : null,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Icon(
              Icons.wallet,
              color: Colors.black,
              size: 30,
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.settings,
                  color: Colors.black,
                ))
          ]),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(primary: Colors.white),
                        onPressed: (choose == false)
                            ? () {
                                setState(() {
                                  controller.jumpToPage(0);
                                  choose = true;
                                });
                              }
                            : null,
                        child: Text(
                          'Home',
                          style: (choose == true)
                              ? const TextStyle(
                                  color: Colors.black, fontSize: 18)
                              : const TextStyle(
                                  color: Colors.grey, fontSize: 18),
                        )),
                    TextButton(
                        style: TextButton.styleFrom(primary: Colors.white),
                        onPressed: (choose == true)
                            ? () {
                                setState(() {
                                  controller.jumpToPage(1);
                                  choose = false;
                                });
                              }
                            : null,
                        child: Text(
                          'Saving',
                          style: (choose == false)
                              ? const TextStyle(
                                  color: Colors.black, fontSize: 18)
                              : const TextStyle(
                                  color: Colors.grey, fontSize: 18),
                        ))
                  ],
                ),
                Container(
                  width: (choose == true)
                      ? MediaQuery.of(context).size.width * 0.59
                      : MediaQuery.of(context).size.width * 0.58,
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 250),
                    alignment: (choose == true)
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.19,
                          height: 3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: PageView(
          onPageChanged: (page) {
            setState(() {
              bottomNavigator = !bottomNavigator;
              choose = !choose;
              sizeCheck = true;
            });
          },
          controller: controller,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: PieChart())),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
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
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 30, vertical: 7),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       const Text(
                      //         'Recent History',
                      //         style: TextStyle(
                      //             fontSize: 16, fontWeight: FontWeight.bold),
                      //       ),
                      //       DropdownButtonHideUnderline(
                      //         child: DropdownButton2(
                      //           items: items
                      //               .map((item) => DropdownMenuItem<String>(
                      //                     value: item,
                      //                     child: Text(
                      //                       item,
                      //                       style: const TextStyle(
                      //                         fontSize: 14,
                      //                       ),
                      //                     ),
                      //                   ))
                      //               .toList(),
                      //           value: selectedValue,
                      //           onChanged: (value) {
                      //             setState(() {
                      //               selectedValue = value as String;
                      //             });
                      //           },
                      //           dropdownDecoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(14),
                      //           ),
                      //           buttonHeight: 40,
                      //           buttonWidth: 100,
                      //           dropdownOverButton: false,
                      //           itemHeight: 40,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            const Center(
              child: Saving(),
            )
          ]),
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
  return ListView(
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
  final income = Income.fromSnapshot(snapshot);
  return HomeHistory(income: income);
}
