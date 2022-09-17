// import 'dart:ffi';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:personal_financial/views/verify.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showpass = true;
  bool valid = false;
  bool submit = false;

  bool check = false;

  bool isLoading = false;

  final _fromKey = GlobalKey<FormState>();

  TextEditingController userCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();

  var errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context, '/');
              },
              icon: const Icon(
                Icons.arrow_back,
              ))
        ]),
      ),
      body: BlurryModalProgressHUD(
        inAsyncCall: isLoading,
        blurEffectIntensity: 4,
        progressIndicator: SpinKitFadingCircle(
          color: Colors.blue,
          size: 90.0,
        ),
        dismissible: false,
        opacity: 0.4,
        color: Colors.black,
        child: Scaffold(
          body: Form(
            key: _fromKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: [Colors.white, Colors.white])),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Container(
                      width: 350,
                      height: 380,
                      decoration: BoxDecoration(
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 7,
                            spreadRadius: 10,
                            offset: Offset(0.0, 3.0),
                          )
                        ],
                        borderRadius: BorderRadius.circular(30).copyWith(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                        gradient: LinearGradient(
                            colors: [Colors.white, Colors.white]),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)
                              .copyWith(topRight: Radius.circular(0)),
                          gradient: LinearGradient(
                              colors: [Colors.white, Colors.white]),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.blue),
                                cursorColor: Colors.blue,
                                controller: emailCont,
                                validator: (email) {
                                  if (email == null || email.isEmpty) {
                                    return "Email can't be blank";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                    // focusedBorder: OutlineInputBorder(
                                    //     borderSide: BorderSide(color: Colors.blue)),
                                    // labelText: "Email",
                                    labelStyle: TextStyle(color: Colors.blue),
                                    hintText: "Enter your email",
                                    hintStyle: TextStyle(color: Colors.blue),
                                    // prefixIconConstraints:
                                    // BoxConstraints(maxHeight: 10, minWidth: 40),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.blue,
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                style: const TextStyle(color: Colors.blue),
                                cursorColor: Colors.blue,
                                controller: passCont,
                                obscuringCharacter: "*",
                                obscureText: showpass,
                                validator: (password) {
                                  if (password == null || password.isEmpty) {
                                    return "Password can't be blank";
                                  } else if (password.length < 6) {
                                    return "Password should be 6 word";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    // focusedBorder: const OutlineInputBorder(
                                    //     borderSide: BorderSide(color: Colors.blue)),
                                    // labelText: "Password",
                                    // labelStyle: const TextStyle(color: Colors.blue),
                                    hintText: "Enter your password",
                                    hintStyle:
                                        const TextStyle(color: Colors.blue),
                                    // prefixIconConstraints:
                                    // BoxConstraints(maxHeight: 10, minWidth: 40),
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: Colors.blue,
                                    ),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showpass = !showpass;
                                          });
                                        },
                                        splashRadius: 5,
                                        icon: showpass
                                            ? const Icon(
                                                Icons.visibility_off,
                                                color: Colors.blue,
                                              )
                                            : const Icon(
                                                Icons.visibility,
                                                color: Colors.blue,
                                              ))),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ))),
                                  onPressed: () async {
                                    // EasyLoading.show(
                                    //     status: 'loading...',
                                    //     maskType: EasyLoadingMaskType.black);
                                    setState(() {
                                      submit = true;
                                      // isLoading = true;
                                    });
                                    // await Future.delayed(const Duration(seconds: 3));
                                    if (_fromKey.currentState!.validate()) {
                                      // await Future.delayed(Duration(seconds: 8),
                                      //     () {
                                      //   setState(() {
                                      //     isLoading = !isLoading;
                                      //   });
                                      // });
                                      try {
                                        final auth = FirebaseAuth.instance;

                                        final newUser = await auth
                                            .createUserWithEmailAndPassword(
                                                email: emailCont.text,
                                                password: passCont.text)
                                            .then((_) {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VerifyScreen()));
                                        });
                                        // await FirebaseAuth.instance.currentUser!
                                        //     .updateDisplayName(userCont.text);
                                        final currentuser =
                                            FirebaseAuth.instance.currentUser;
                                        currentuser!.sendEmailVerification();
                                        setState(() {
                                          // isLoading = false;
                                          // Navigator.pushNamed(context, '/login');
                                          userCont.clear();
                                          emailCont.clear();
                                          passCont.clear();
                                        });

                                        // SharedPreferences prefs =
                                        // await SharedPreferences.getInstance();

                                        // prefs.setString(
                                        // 'UserID', newUser.user!.uid);
                                      } on FirebaseException catch (e) {
                                        if (e.code == 'user-not-found') {
                                          errorMessage =
                                              'No user found with this E-mail';
                                        } else if (e.code == 'wrong-password') {
                                          errorMessage = ' Wrong password !';
                                        } else {
                                          errorMessage = e.code;
                                        }
                                        // setState(() {
                                        //   isLoading = false;
                                        // });
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(errorMessage),
                                                backgroundColor: Colors.red,
                                                duration: const Duration(
                                                    seconds: 2)));
                                      } catch (e) {
                                        print(e);
                                        // setState(() {
                                        //   isLoading = false;
                                        // });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(e.toString()),
                                                backgroundColor: Colors.red,
                                                duration: const Duration(
                                                    seconds: 2)));
                                      }
                                    }

                                    // if (_fromKey.currentState!.validate()) {
                                    //   SharedPreferences prefs =
                                    //       await SharedPreferences.getInstance();
                                    //   prefs.setString('userValue', userCont.text);
                                    //   prefs.setString('passValue', passCont.text);
                                    //   setState(() {
                                    //     Navigator.pushNamed(context, '/login');
                                    //     userCont.clear();
                                    //     passCont.clear();
                                    //   });
                                    // EasyLoading.showError('Failed with Error');
                                    // EasyLoading.showSuccess("Great Success!");
                                  },
                                  // style: ElevatedButton.styleFrom(
                                  //     primary: Color.fromARGB(235, 229, 60, 60)),
                                  child: const Text(
                                    "Register",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Existing user?",
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    child: const Text(
                                      'login',
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
