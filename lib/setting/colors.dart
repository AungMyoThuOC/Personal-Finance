import 'package:flutter/material.dart';

import '../presentationColor/shared/page_wrapper.dart';
import '../presentationColor/widgets/priary_color_switcher.dart';

class ColorPage extends StatelessWidget {
  const ColorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            const SizedBox(
              width: 40,
            ),
            const Text(
              "Colors",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: PageWrapper(
          body: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          // SizedBox(
          //   height: 30,
          // ),
          // ThemeSwitcher(),
          const SizedBox(
            height: 20,
          ),
          const PrimaryColorSwitcher(),
        ],
      )),
    );
  }
}
