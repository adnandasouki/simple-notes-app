import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usertrack/screens/note/notes.dart';
import 'package:usertrack/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'firebase_options.dart';

void main() async {
  // Initiate Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform
  );

  // Authentication
  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print(' ------------> User is currently signed out!');
    } else {
      print(' ------------> User is signed in!');
    }
  });

  // Database (Firestore)
  // FirebaseFirestore firestore = FirebaseFirestore.instance;

  // App
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: false),
      debugShowCheckedModeBanner: false,
      title: 'User Track',
      home:
          (FirebaseAuth.instance.currentUser != null &&
                  FirebaseAuth.instance.currentUser!.emailVerified)
              ? Notes()
              : LoginScreen(),
    );
  }
}
