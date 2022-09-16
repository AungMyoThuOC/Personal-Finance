import 'package:flutter/material.dart';

class GetStartPage extends StatefulWidget {
  const GetStartPage({Key? key}) : super(key: key);

  @override
  State<GetStartPage> createState() => _GetStartPageState();
}

class _GetStartPageState extends State<GetStartPage> {
  bool isLoading = false;

  bool main = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                // decoration: const BoxDecoration(
                //     image: DecorationImage(
                //         image: AssetImage('images/whatsappbg.jpg'), fit: BoxFit.cover)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        const Text(
                          "Welcome",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Automatic identity verification which enables you to verify your identity",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/Plastic-money.png'))),
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 45,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pushNamed(
                                            context, '/register');
                                      },
                                      // style: ElevatedButton.styleFrom(
                                      //     primary: Color.fromARGB(235, 22, 172, 132)),
                                      child: const Text(
                                        "Register",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 45,
                                  child: MaterialButton(
                                      onPressed: () async {
                                        Navigator.pushNamed(context, '/login');
                                      },
                                      shape: const RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.black38)),
                                      // style: ElevatedButton.styleFrom(
                                      //     primary:
                                      //         const Color.fromARGB(255, 135, 19, 41)),
                                      child: const Text(
                                        "Login",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent),
                                      )),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ))),
      ),
    );
  }
}
