import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usertrack/widgets/custom_input_field.dart';
import 'package:usertrack/widgets/custom_logo.dart';
import 'package:usertrack/widgets/custom_material_button.dart';
import 'package:usertrack/screens/note/notes.dart';
import 'package:usertrack/screens/auth/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25),
                // Logo Container
                CustomLogo(),

                SizedBox(height: 25),

                Text(
                  'Login',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Login to continue',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),

                SizedBox(height: 25),

                // Email Address Field
                Text(
                  'Email Address',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                CustomInputField(
                  hintText: 'Email Address',
                  controller: emailController,
                ),

                SizedBox(height: 20),

                // Password Field
                Text(
                  'Password',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                CustomInputField(
                  hintText: 'Password',
                  controller: passwordController,
                ),

                // Forgot Password
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      if (emailController.text.trim().isEmpty) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'Please enter your email address.',
                        ).show();
                        return;
                      }

                      await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: emailController.text,
                      );

                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.rightSlide,
                        title: 'Info',
                        desc: 'A password reset has been sent to your email.',
                      ).show();
                    },
                    child: Text(
                      'Forget Password?',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Login Button
                CustomMaterialButton(
                  text: 'Login',
                  onPressed: () async {
                    print('--- email: ${emailController.text}');
                    print('--- password: ${passwordController.text}');

                    if (emailController.text.trim().isEmpty ||
                        passwordController.text.trim().isEmpty) {
                      print('Exeption: Empty field detected');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'Please enter both email and password.',
                      ).show();
                      return;
                    }
                    try {
                      // ignore: unused_local_variable
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                      if (FirebaseAuth.instance.currentUser!.emailVerified) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Notes()),
                        );
                      } else {
                        FirebaseAuth.instance.currentUser!
                            .sendEmailVerification();
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'Info',
                          desc: 'Please verify your email before logging in.',
                        ).show();
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'no-user-found') {
                        print('111111111No user found for that email.');
                        print('22222222No user found for that email.');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'No user found for that email.',
                        ).show();
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc:
                              'Wrong password or email provided for that user.',
                        ).show();
                      } else if (e.code == 'invalid-email') {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'Please enter a valid email.',
                        ).show();
                      } else {
                        print('FirebaseAuthException code: ${e.code}');
                      }
                    } catch (e) {
                      print('unhandled exeption: $e');
                    }
                  },
                ),
                SizedBox(height: 15),

                // Create a new account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 0,
                  children: [
                    Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Create a new account',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
