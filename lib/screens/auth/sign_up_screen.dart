import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usertrack/db/users_db_helper.dart';
import 'package:usertrack/screens/auth/login_screen.dart';
import 'package:usertrack/widgets/custom_input_field.dart';
import 'package:usertrack/widgets/custom_material_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  UsersDbHelper usersDbHelper = UsersDbHelper();

  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    username.dispose();
    password.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      body: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign up',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Create a new account',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 15),

                // first name
                Text(
                  'First Name',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                CustomInputField(hintText: 'First Name', controller: firstName),
                SizedBox(height: 10),

                // last name
                Text(
                  'Last Name',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                CustomInputField(hintText: 'Last Name', controller: lastName),
                SizedBox(height: 10),

                // username
                Text(
                  'Username',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                CustomInputField(hintText: 'Username', controller: username),
                SizedBox(height: 20),

                // email address
                Text(
                  'Email Address',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                CustomInputField(hintText: 'Email Address', controller: email),

                SizedBox(height: 20),
                // Password
                Text(
                  'Password',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                CustomInputField(hintText: 'Password', controller: password),
                SizedBox(height: 40),
                // Create Account Button
                CustomMaterialButton(
                  text: 'Create Account',
                  onPressed: () async {
                    try {
                      // ignore: unused_local_variable
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );

                      // Add user to db
                      usersDbHelper.createUser(
                        id: FirebaseAuth.instance.currentUser!.uid,
                        firstName: firstName.text,
                        lastName: lastName.text,
                        username: username.text,
                        password: password.text,
                        email: email.text,
                      );

                      print(' ---------------- Account Created');

                      // Go to login screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'The account already exists for that email.',
                        ).show();
                      } else if (e.code == 'weak-password') {
                        print('Password should be at least 6 characters.');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'Password should be at least 6 characters.',
                        ).show();
                      } else {
                        print('FirebaseExeption code: ${e.code}');
                      }
                    } catch (e) {
                      print('Unhandled Exeption: $e');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
