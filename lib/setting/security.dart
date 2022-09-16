import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class SecurityPage extends StatefulWidget {
  SecurityPage({Key? key}) : super(key: key);

  void _changePassword(String currentPassword, String newPassword) async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email!, password: currentPassword);
    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        print(newPassword);
      }).catchError((error) {});
    }).catchError((err) {});
  }

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  TextEditingController currpass = TextEditingController();
  TextEditingController newpass = TextEditingController();
  TextEditingController confipass = TextEditingController();

  // bool showpass = true;
  bool currshowpass = true;
  bool newshowpass = true;
  bool confishowpass = true;

  bool submit = false;

  var errorMessage = '';
  final formKey = GlobalKey<FormState>();

  // late String value;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Security",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(color: Colors.blue, fontSize: 15),
                    cursorColor: Colors.blue,
                    controller: currpass,
                    obscuringCharacter: "*",
                    obscureText: currshowpass,
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return "Please enter a current password";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      // labelStyle: TextStyle(
                      //   color: Colors.blue,
                      // ),
                      // labelText: "Email",
                      hintText: "Current Password",
                      hintStyle: const TextStyle(color: Colors.blue),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              currshowpass = !currshowpass;
                            });
                          },
                          splashRadius: 5,
                          icon: currshowpass
                              ? const Image(
                                  image: AssetImage('images/hidepass.png'),
                                )
                              : const Image(
                                  image: AssetImage('images/showpass.png'))),
                      prefixIconConstraints:
                          const BoxConstraints(maxHeight: 10, minWidth: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(color: Colors.blue, fontSize: 15),
                    cursorColor: Colors.blue,
                    controller: newpass,
                    obscuringCharacter: "*",
                    obscureText: newshowpass,
                    validator: (password) {
                      if (password!.isEmpty) {
                        return "Please enter new password";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      // labelStyle: TextStyle(
                      //   color: Colors.blue,
                      // ),
                      // labelText: "Email",
                      hintText: "New Password",
                      hintStyle: const TextStyle(color: Colors.blue),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              newshowpass = !newshowpass;
                            });
                          },
                          splashRadius: 5,
                          icon: newshowpass
                              ? const Image(
                                  image: AssetImage('images/hidepass.png'),
                                )
                              : const Image(
                                  image: AssetImage('images/showpass.png'))),
                      prefixIconConstraints:
                          const BoxConstraints(maxHeight: 10, minWidth: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(color: Colors.blue, fontSize: 15),
                    cursorColor: Colors.blue,
                    controller: confipass,
                    obscuringCharacter: "*",
                    obscureText: confishowpass,
                    validator: (password) {
                      if (password!.isEmpty) {
                        return "Please enter re-password";
                      } else if (password != newpass.text) {
                        return "Password don't match";
                      } else {
                        return null;
                      }
                    },
                    // validator: (value) =>
                    //     MatchValidator(errorText: "Password don't match")
                    //         .validateMatch(value!, newpass.text),
                    decoration: InputDecoration(
                        prefixIconConstraints:
                            const BoxConstraints(maxHeight: 10, minWidth: 20),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        // labelStyle: TextStyle(
                        //   color: Colors.blue,
                        // ),
                        // labelText: "Email",
                        hintText: "Confirm Password",
                        hintStyle: const TextStyle(color: Colors.blue),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                confishowpass = !confishowpass;
                              });
                            },
                            splashRadius: 5,
                            icon: confishowpass
                                ? const Image(
                                    image: AssetImage('images/hidepass.png'),
                                  )
                                : const Image(
                                    image: AssetImage('images/showpass.png')))),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            submit = true;
                          });
                          if (formKey.currentState!.validate()) {
                            try {
                              var currentUser;
                              if (currentUser.user!.uid != null) {
                                // isLoading = false;
                                // ignore: use_build_context_synchronously

                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacementNamed(
                                    context, '/setting');
                              }
                            } on FirebaseException catch (e) {
                              if (e.code == "password don't match") {
                                errorMessage = "Password don't macth";
                              } else if (e.code == 'wrong-password') {
                                errorMessage = ' Wrong password !';
                              } else {
                                errorMessage = e.code;
                              }
                              // setState(() {
                              //   isLoading = false;
                              // });
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(errorMessage),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 2)));
                            } catch (e) {
                              // setState(() {
                              //   isLoading = false;
                              // });
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(e.toString()),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 2)));
                            }
                          }
                        },
                        child: const Text("Save"),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
