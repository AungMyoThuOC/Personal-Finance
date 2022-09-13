import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:personal_financial/models/saving.dart';
import 'package:personal_financial/data_repository.dart';
import 'saving_details.dart';
import 'package:pull_down_button/pull_down_button.dart';

class SavingList extends StatefulWidget {
  const SavingList({Key? key, required this.saving}) : super(key: key);
  final Saving saving;

  @override
  State<SavingList> createState() => _SavingListState();
}

class _SavingListState extends State<SavingList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        Text('${widget.saving.autoID}'),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SavingDetails(
                            saving: widget.saving,
                          )));
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.android,
                                  size: 45,
                                  color: Colors.blueAccent,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      widget.saving.target,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '0/${widget.saving.amount}',
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          PullDownButton(
                            backgroundColor: Colors.white60,
                            itemBuilder: (context) => [
                              PullDownMenuItem(
                                title: 'Edit',
                                onTap: () {},
                              ),
                              const PullDownMenuDivider(),
                              PullDownMenuItem(
                                title: 'Delete',
                                onTap: () => {
                                  DataRepository()
                                      .deleteSaving(widget.saving.autoID!)
                                },
                              ),
                            ],
                            position: PullDownMenuPosition.under,
                            buttonBuilder: (context, showMenu) => Container(
                              child: CupertinoButton(
                                onPressed: showMenu,
                                padding: EdgeInsets.zero,
                                child:
                                    const Icon(CupertinoIcons.ellipsis_circle),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LinearPercentIndicator(
                        animation: true,
                        lineHeight: 12,
                        animationDuration: 2000,
                        percent: 0.9,
                        barRadius: const Radius.circular(10),
                        center: const Text(
                          "90%",
                          style: TextStyle(fontSize: 10),
                        ),
                        progressColor: Colors.greenAccent,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
