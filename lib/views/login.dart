import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:form_field_validator/form_field_validator.dart';
import 'package:personal_financial/views/reset.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:form_field_validator/form_field_validator.dart';
// import 'forgotpass.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showpass = true;
  bool valid = false;

  bool submit = false;

  bool check = false;

  late bool isLoading = false;
  // bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
        progressIndicator: const SpinKitFadingCircle(
          color: Colors.blue,
          size: 90.0,
        ),
        dismissible: false,
        opacity: 0.4,
        color: Colors.black,
        child: Scaffold(
          body: Form(
            key: _formKey,
            child: Center(
              child: Stack(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      gradient:
                          LinearGradient(colors: [Colors.white, Colors.white]),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Container(
                        width: 350,
                        height: 360,
                        decoration: BoxDecoration(
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 7,
                                spreadRadius: 10,
                                offset: Offset(0.0, 3.0),
                              )
                              // BoxShadow(
                              //   color: Colors.grey.withOpacity(0.5),
                              //   spreadRadius: 5,
                              //   blurRadius: 7,
                              //   offset: Offset(0, 3),
                              // )
                            ],
                            borderRadius: BorderRadius.circular(30).copyWith(
                                topRight: const Radius.circular(20),
                                topLeft: const Radius.circular(20)),
                            gradient: const LinearGradient(
                                colors: [Colors.white, Colors.white])),
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30).copyWith(
                                topRight: const Radius.circular(20),
                                topLeft: const Radius.circular(20)),
                            gradient: const LinearGradient(
                                colors: [Colors.white, Colors.white]),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(
                                      color: Colors.blue, fontSize: 15),
                                  cursorColor: Colors.blue,
                                  controller: emailController,
                                  validator: (email) {
                                    if (email == null || email.isEmpty) {
                                      return "Email can't be blank";
                                      // ignore: unrelated_type_equality_checks
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                      // focusedBorder: OutlineInputBorder(
                                      //     borderSide: BorderSide(color: Colors.blue)),
                                      // labelStyle: TextStyle(
                                      //   color: Colors.blue,
                                      // ),
                                      // labelText: "Email",
                                      hintText: "Enter your Email",
                                      hintStyle: TextStyle(color: Colors.blue),
                                      // prefixIconConstraints:
                                      // BoxConstraints(maxHeight: 10, minWidth: 20),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Icon(
                                          Icons.mail,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
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
                                  controller: passwordController,
                                  obscuringCharacter: "*",
                                  obscureText: showpass,
                                  validator: (password) {
                                    if (password == null || password.isEmpty) {
                                      return "Password can't be blank";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      // prefixIconConstraints:
                                      // BoxConstraints(maxHeight: 10, minWidth: 30),
                                      // focusedBorder: const OutlineInputBorder(
                                      //     borderSide: BorderSide(color: Colors.blue)),
                                      // labelStyle: const TextStyle(color: Colors.blue),
                                      // labelText: "Password",
                                      hintText: "Enter your password",
                                      hintStyle:
                                          const TextStyle(color: Colors.blue),
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
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 15,
                                      ),
                                    ),
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ResetScreen())),
                                    //   onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                    //     builder: (context) => ForgotPasswordPage(),
                                    //   )),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ))),
                                      onPressed: () async {
                                        // EasyLoading.show(
                                        //     status: 'loading...',
                                        //     maskType: EasyLoadingMaskType.black);
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        final String? username =
                                            prefs.getString('UserID');
                                        prefs.setString('password',
                                            passwordController.text);
                                        setState(() {
                                          submit = true;
                                          print('$username');
                                        });
                                        if (_formKey.currentState!.validate()) {
                                          // await Future.delayed(Duration(seconds: 5),
                                          //     () {
                                          //   setState(() {
                                          //     isLoading = !isLoading;
                                          //   });
                                          // });
                                          // setState(() {
                                          //   isLoading = true;
                                          // });
                                          try {
                                            final auth = FirebaseAuth.instance;
                                            UserCredential currentUser =
                                                await auth
                                                    .signInWithEmailAndPassword(
                                                        email: emailController
                                                            .text,
                                                        password:
                                                            passwordController
                                                                .text);
                                            print(currentUser.user!.uid);
                                            if (currentUser.user!.uid != null) {
                                              // isLoading = false;
                                              // ignore: use_build_context_synchronously
                                              Navigator.popUntil(context,
                                                  ModalRoute.withName('/'));
                                              // ignore: use_build_context_synchronously
                                              Navigator.pushReplacementNamed(
                                                  context, '/home');
                                              emailController.clear();
                                              passwordController.clear();
                                            }
                                          } on FirebaseException catch (e) {
                                            if (e.code == 'user-not-found') {
                                              errorMessage =
                                                  'No user found with this E-mail';
                                            } else if (e.code ==
                                                'wrong-password') {
                                              errorMessage =
                                                  ' Wrong password !';
                                            } else {
                                              errorMessage = e.code;
                                            }

                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Container(
                                                        height: 20,
                                                        child:
                                                            Text(errorMessage)),
                                                    backgroundColor: Colors.red,
                                                    duration: const Duration(
                                                        seconds: 2)));
                                          } catch (e) {
                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Container(
                                                        height: 20,
                                                        child:
                                                            Text(e.toString())),
                                                    backgroundColor: Colors.red,
                                                    duration: const Duration(
                                                        seconds: 2)));
                                          }
                                        }
                                        // EasyLoading.showError('Failed with Error');
                                        // EasyLoading.showSuccess("Great Success!");
                                      },
                                      child: const Text(
                                        "Login",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
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
