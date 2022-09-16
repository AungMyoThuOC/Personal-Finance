import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:personal_financial/Components/home_history.dart';

import 'saving_details.dart';
import '/models/saving.dart';
import '/data_repository.dart';
import 'saving_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:personal_financial/firebase_options.dart';

class ViewSaving extends StatefulWidget {
  const ViewSaving({super.key});

  @override
  State<ViewSaving> createState() => _SavingState();
}

class _SavingState extends State<ViewSaving> {
  bool bottomNavigator = true;
  final DataRepository repository = DataRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (bottomNavigator == true)
          ? SizedBox(
              width: 45,
              child: FloatingActionButton(
                  elevation: 0,
                  onPressed: () {
                    Navigator.pushNamed(context, '/saving_add');
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  )),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: StreamBuilder<QuerySnapshot>(
          stream: repository.getSavingStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();

            return _buildList(context, snapshot.data?.docs ?? []);
          }),
    );
  }
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
  final saving = Saving.fromSnapshot(snapshot);
  return SavingList(saving: saving);
}
