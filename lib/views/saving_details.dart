import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:personal_financial/Components/home_history.dart';
import 'package:personal_financial/data_repository.dart';
import 'package:personal_financial/models/remaning_saving.dart';
import 'package:personal_financial/models/saving.dart';

class SavingDetails extends StatefulWidget {
  SavingDetails({Key? key, required this.saving}) : super(key: key);
  Saving? saving;
  @override
  State<SavingDetails> createState() => _SavingDetailsState();
}

class _SavingDetailsState extends State<SavingDetails> {
  int _currentSlider = 1000;
  bool check = true;
  AnimateIconController controller = AnimateIconController();
  bool visible = false;
  var opacity = 0.0;
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
        ),
        body: Stack(children: [
          Column(
            children: [
              Text(widget.saving!.autoID.toString()),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white,
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 30.0,
                        spreadRadius: 1,
                        offset: Offset(0.0, 3.0),
                      ),
                    ],
                  ),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          (check)
                              ? CircularPercentIndicator(
                                  radius: 60.0,
                                  lineWidth: 13.0,
                                  animation: true,
                                  percent: 0.7,
                                  center: const Text(
                                    "70%",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                  footer: Column(
                                    children: const [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "0/2000 MMK",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: Colors.purple,
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: LinearPercentIndicator(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    animation: true,
                                    lineHeight: 20.0,
                                    animationDuration: 2000,
                                    percent: 0.9,
                                    center: const Text("70%"),
                                    barRadius: const Radius.circular(10),
                                    progressColor: Colors.greenAccent,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Table(children: [
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 15.0,
                            ),
                            child: Text(
                              'Target Name:',
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25.0),
                            child: Text(
                              '${widget.saving!.target}',
                              textAlign: TextAlign.end,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            child: Text(
                              'Target Price:',
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25.0),
                            child: Text(
                              '${widget.saving!.amount}',
                              textAlign: TextAlign.end,
                              style: const TextStyle(fontSize: 16),
                            ),
                          )
                        ]),
                        const TableRow(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            child: Text(
                              'Remaining',
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            child: Text(
                              '2000',
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        ]),
                      ]),
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blueAccent,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                openDialog();
                              });
                              // setState(() {
                              //   opacity = opacity == 0.0 ? 1 : 0;
                              // });
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ))
                  ]),
                ),
              ),
              NotificationListener(
                onNotification: (ScrollNotification notify) {
                  setState(() {
                    if (notify.metrics.pixels > 30) {
                      check = false;
                    } else {
                      check = true;
                    }
                  });
                  return false;
                },
                child: Container(
                  height: 100,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Container(
                        height: 200,
                      ),
                      Container(
                        height: 200,
                      ),
                      Container(
                        height: 200,
                      ),
                      Container(
                        height: 200,
                      )
                    ],
                  )),
                ),
              ),
            ],
          ),
          // Positioned(
          //     left: 80,
          //     bottom: 280,
          //     child: AnimatedOpacity(
          //       duration: Duration(milliseconds: 500),
          //       opacity: opacity,
          //       child: Container(
          //         decoration: BoxDecoration(
          //           color: Colors.black,
          //           borderRadius: BorderRadius.circular(10),
          //           boxShadow: [
          //             BoxShadow(
          //               offset: const Offset(0, 3),
          //               blurRadius: 2,
          //               color: Colors.black.withOpacity(0.2),
          //             ),
          //           ],
          //         ),
          //         child: Container(
          //           width: 200,
          //           height: 200,
          //           color: Colors.black,
          //           child: Column(
          //             children: [
          //               TextField(
          //                 controller: amountController,
          //                 style: const TextStyle(color: Colors.white),
          //                 decoration: InputDecoration(
          //                   hintText: "Amount",
          //                   hintStyle: const TextStyle(color: Colors.grey),
          //                   enabledBorder: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(10),
          //                     borderSide: const BorderSide(
          //                         width: 1,
          //                         color: Color.fromARGB(255, 224, 224, 224)),
          //                   ),
          //                   focusedBorder: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(10),
          //                     borderSide: const BorderSide(
          //                         width: 1,
          //                         color: Color.fromARGB(255, 177, 177, 177)),
          //                   ),
          //                 ),
          //               ),
          //               Row(
          //                 children: [
          //                   ElevatedButton(
          //                       onPressed: () {
          //                         DataRepository().updateRemaining(
          //                             widget.saving!.autoID.toString(),
          //                             Remaining(
          //                                 int.parse(amountController.text),
          //                                 date: DateTime.now()));
          //                       },
          //                       child: const Text('Save'))
          //                 ],
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     )),
        ]));
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              content: Container(
                width: 100,
                height: 50,
                child: Slider(
                  value: _currentSlider.toDouble(),
                  divisions: 20,
                  min: 0,
                  max: 30000,
                  label: _currentSlider.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSlider = value.toInt();
                      print(_currentSlider);
                      amountController.text = _currentSlider.toString();
                    });
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: cancel, 
                  child: const Text("Cancel")
                ),
                TextButton(
                  onPressed: save, 
                  child: const Text("Save")
                )
              ],
            );
          })));

  void save() {
    Navigator.pop(context);
  }

  void cancel() {
    Navigator.of(context).pop();
  }
}
