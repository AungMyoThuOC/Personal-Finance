import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:personal_financial/models/income.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:personal_financial/data_repository.dart';
import 'package:personal_financial/views/add_income.dart';
import 'package:personal_financial/views/edit_income.dart';

class HomeHistory extends StatelessWidget {
  HomeHistory({Key? key, required this.income}) : super(key: key);
  final Income income;
  List<IconData> navBarItem = [
    Icons.family_restroom,
    Icons.cast_for_education,
    Icons.home,
    Icons.car_crash,
    Icons.shop,
    Icons.phone,
    Icons.percent,
    Icons.laptop,
    Icons.handshake,
    Icons.book_online_outlined,
    Icons.face,
    Icons.camera_alt,
    Icons.cabin,
    Icons.tire_repair,
    Icons.local_taxi,
    Icons.food_bank,
    Icons.hotel_class,
    Icons.gamepad_sharp,
    Icons.abc,
    Icons.hail,
    Icons.wallet_giftcard,
    Icons.train,
    Icons.phone_android,
    Icons.icecream,
    Icons.star,
    Icons.monetization_on,
    Icons.ac_unit_sharp,
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Slidable(
        key: Key(income.autoID.toString()),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {
            DataRepository().deleteIncome(income.autoID.toString());
          }),
          children: [
            SlidableAction(
              onPressed: (context) {
                DataRepository().deleteIncome(income.autoID.toString());
              },
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        startActionPane: ActionPane(
          motion: ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditIncome(
                      income: income,
                    )));
          }),
          children: [
            SlidableAction(
              flex: 2,
              onPressed: (mm) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditIncome(
                          income: income,
                        )));
              },
              backgroundColor: Color(0xFF7BC043),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        child: ListTile(
          title: Container(
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
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          navBarItem[int.parse(income.category)],
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${income.catName}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    Container(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (income.income == true)
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      'Income',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      'Outcome',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: EdgeInsets.only(right: 22),
                            child: Text(
                              "${income.amount}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
