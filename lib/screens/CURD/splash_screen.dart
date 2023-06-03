import 'dart:async';

import 'package:firestore_example/screens/auth_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AuthScreen())
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://support.aspnetzero.com/QA/files/2359_ae4d287e49b0108e5571e33132b12e7a.jpg"),
                fit: BoxFit.fill)),
        child: const Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Text(
              "Dheeraj Prajapati",
              style: TextStyle(color: Colors.transparent, fontSize: 15),
            ),
            Spacer(),
            Text(
              "College Project",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            Spacer(),
            Text(
              "Dheeraj Prajapati",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
