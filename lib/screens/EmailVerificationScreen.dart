import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  final _auth = FirebaseAuth.instance;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = _auth.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
          Duration(seconds: 3), (timer) => checkEmailVerification());
    }
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  void checkEmailVerification() async {
    try {
      isEmailVerified = _auth.currentUser!.emailVerified;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return false
        ? const HomeScreen()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0,
              title: const Text(
                "Email Verification",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email_outlined,size: 100,),
                  Text("Please verify your email before login"),
                  MaterialButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {},
                    child: Text("Resend Verification Link",style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
          );
  }
}