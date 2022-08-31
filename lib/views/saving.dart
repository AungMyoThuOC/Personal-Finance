import 'package:flutter/material.dart';
import 'package:personal_financial/Components/home_history.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'saving_details.dart';

class Saving extends StatefulWidget {
  const Saving({super.key});

  @override
  State<Saving> createState() => _SavingState();
}

class _SavingState extends State<Saving> {
  bool bottomNavigator = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (bottomNavigator == true)
          ? SizedBox(
              width: 45,
              child: FloatingActionButton(
                  elevation: 0,
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  )),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
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
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/saving_details');
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
                              width: 150,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Icon(
                                    Icons.android,
                                    size: 45,
                                    color: Colors.blueAccent,
                                  ),
                                  Column(
                                    children: const [
                                      Text(
                                        'Target',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '0/2000',
                                        style: TextStyle(color: Colors.black),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                customButton: const Icon(
                                  Icons.more_vert_outlined,
                                  size: 30,
                                  color: Colors.blue,
                                ),
                                customItemsIndexes: const [3],
                                customItemsHeight: 8,
                                items: [
                                  ...MenuItems.firstItems.map(
                                    (item) => DropdownMenuItem<MenuItem>(
                                      value: item,
                                      child: MenuItems.buildItem(item),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  MenuItems.onChanged(
                                      context, value as MenuItem);
                                },
                                itemHeight: 48,
                                itemPadding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                dropdownWidth: 130,
                                dropdownPadding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.white,
                                ),
                                dropdownElevation: 8,
                                offset: const Offset(0, 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                color: Color.fromARGB(255, 171, 199, 235),
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 11,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.blue,
                              ),
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: 11,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [edit, delete];

  static const edit = MenuItem(text: 'Edit', icon: Icons.edit);
  static const delete = MenuItem(text: 'Delete', icon: Icons.delete);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.black, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.edit:
        //Do something
        break;
      case MenuItems.delete:
        //Do something
        break;
    }
  }
}
