import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //  backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Setting",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/color');
                  },
                  child: const Text(
                    "Colors",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      // color: Colors.black
                    ),
                  )),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/language');
                  },
                  child: const Text(
                    "Language",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      // color: Colors.black
                    ),
                  )),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/security');
                  },
                  child: const Text(
                    "Security",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      // color: Colors.black,
                    ),
                  )),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: () {
                  },
                  child: const Text(
                    "Reset Data",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
