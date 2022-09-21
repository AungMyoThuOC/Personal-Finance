import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:personal_financial/models/remaning_saving.dart';
import 'package:personal_financial/models/saving.dart';
import '/data_repository.dart';
import 'package:personal_financial/models/remaning_saving.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class HistRemain extends StatefulWidget {
  HistRemain({Key? key, required this.remaining, required this.autoID})
      : super(key: key);
  final Remaining remaining;
  String autoID;

  @override
  State<HistRemain> createState() => _RemainingState();
}

class _RemainingState extends State<HistRemain> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 3),
              blurRadius: 2,
              color: Colors.black.withOpacity(0.2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 22),
                    child: Text(
                      "${widget.remaining.amount}",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  DataRepository().deleteRemaining(
                      widget.autoID, widget.remaining.remainID.toString());
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                ))
          ]),
        ),
      ),
    );
  }
}
