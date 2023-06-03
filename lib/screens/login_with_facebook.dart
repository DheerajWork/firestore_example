import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginWithFacebook extends StatefulWidget {
  const LoginWithFacebook({Key? key}) : super(key: key);

  @override
  State<LoginWithFacebook> createState() => _LoginWithFacebookState();
}

class _LoginWithFacebookState extends State<LoginWithFacebook> {
  String userEmail = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login With Facebook"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("User Email : $userEmail"),
          ElevatedButton(
            child: const Text("Login"),
            onPressed: (){
              signInWithFacebook();
            },
          ),
          ElevatedButton(
            child: const Text("Logout"),
            onPressed: (){},
          ),
        ],
      ),
    );
  }
  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile', 'user_birthday']
    );

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    final userDataF = await FacebookAuth.instance.getUserData();

    userEmail  = userDataF['email'];
    print(userEmail);


    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
}
