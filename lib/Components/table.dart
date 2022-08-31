import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class TableInOutCome extends StatelessWidget {
  const TableInOutCome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
        defaultColumnWidth: const FixedColumnWidth(130.0),
        children: const [
          TableRow(children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 15.0,
              ),
              child: Text(
                'Income',
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                '10000',
                textAlign: TextAlign.end,
              ),
            ),
          ]),
          TableRow(children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                'Saving',
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                '1000',
                textAlign: TextAlign.end,
              ),
            )
          ]),
          TableRow(children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                'Outcome',
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                '1000',
                textAlign: TextAlign.end,
              ),
            )
          ])
        ]);
  }
}
