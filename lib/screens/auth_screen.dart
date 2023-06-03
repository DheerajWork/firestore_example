import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_example/main.dart';
import 'package:firestore_example/screens/CURD/home_page.dart';
import 'package:firestore_example/screens/login_with_facebook.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:linkedin_login/linkedin_login.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  String bgImg = "https://images.wallpaperscraft.com/image/single/lamp_wall_brick_137605_225x300.jpg";

  // Map<String,dynamic>? _userData;
  // AccessToken? _accessToken;
  // bool _checking = true;
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _checkIfisLoggedIn();
  // }
  //
  // _checkIfisLoggedIn() async{
  //   final accessToken = await FacebookAuth.instance.accessToken;
  //
  //   setState(() {
  //     _checking = false;
  //   });
  //   if(accessToken !=null){
  //     print(accessToken.toJson());
  //     final userData = await FacebookAuth.instance.getUserData();
  //     _accessToken = accessToken;
  //     setState(() {
  //       _userData = userData;
  //     });
  //   }else{
  //     _login();
  //   }
  // }
  //
  // _login()async{
  //   final LoginResult result = await FacebookAuth.instance.login();
  //   if(result.status==LoginStatus.success){
  //     _accessToken = result.accessToken;
  //
  //     final userData = await FacebookAuth.instance.getUserData();
  //     _userData = userData;
  //   }else{
  //     print(result.status);
  //     print(result.message);
  //   }
  //   setState(() {
  //     _checking = false;
  //   });
  // }
  //
  // _logout()async{
  //   await FacebookAuth.instance.logOut();
  //   _accessToken = null;
  //   _userData = null;
  //   setState(() {
  //
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(bgImg),fit: BoxFit.fill)),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 500,
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  child: const Text("Login With Google",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20)),
                  onPressed: () {
                    signInWithGoogle();
                  },
                ),
              ),
              const Spacer(),
              const Text("Dheeraj Prajapati",style: TextStyle(color: Colors.white,fontSize: 15),),
              // const SizedBox(
              //   height: 5,
              // ),
              const SizedBox(
                height: 20,
              ),
              // ElevatedButton(
              //   child: const Text("Login With Facebook"),
              //   onPressed: (){
              //     Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const LoginWithFacebook()));
              //   },
              // ),
              // ElevatedButton(
              //   child: const Text("Login With Linkedin"),
              //   onPressed: (){
              //
              //     // Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const LoginWithFacebook()));
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser!.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user!.displayName);
    print(userCredential.user!.email);

    if (userCredential.user != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => HomePage(
                userName: userCredential.user!.displayName,
                email: userCredential.user!.email,
                img: userCredential.user!.photoURL,
                number: userCredential.user!.phoneNumber,
              ),
      ),
      );
    }
  }
}
