import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_example/screens/CURD/home_page.dart';
import 'package:firestore_example/screens/CURD/notes_screen.dart';
import 'package:firestore_example/screens/CURD/splash_screen.dart';
import 'package:firestore_example/screens/auth_screen.dart';
import 'package:firestore_example/screens/chat_screen.dart';
import 'package:firestore_example/screens/create_note_screen.dart';
import 'package:firestore_example/screens/login_with_facebook.dart';
import 'package:firestore_example/screens/my_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {

  final String? userName;
  final String? email;
  final String? img;
  final String? number;
  const HomeScreen({this.userName,Key? key, this.email, this.img, this.number}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.userName}"),
        actions: [
          IconButton(
            onPressed: ()async{
              await GoogleSignIn().signOut();
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.power_settings_new),
          )
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(widget.img!),
            const SizedBox(
              height: 10,
            ),
            Text("${widget.email}"),
            Text("${widget.number}"),
          ],
        ),
      ),
    );
  }
}


