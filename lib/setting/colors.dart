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
        title: const Text("Colors"),
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
