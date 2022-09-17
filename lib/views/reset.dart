import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  // late String email;
  // final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("Password reset link sent! Check your email"),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Receive and email to\nreset  your password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.blue, fontSize: 15),
                  cursorColor: Colors.blue,
                  controller: emailController,
                  decoration: const InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.blue),
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
                height: 20,
              ),
              MaterialButton(
                onPressed: passwordReset,
                color: Theme.of(context).colorScheme.secondary,
                child: const Text(
                  "Reset Password",
                  style: TextStyle(color: Colors.white),
                ),
                // color: Colors.blue[200],
              )
            ],
          ),
        ),
      ),
    );
  }
}
