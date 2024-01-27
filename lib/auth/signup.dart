import 'package:demo_application/auth/login_screen.dart';
import 'package:demo_application/core/componets/custom_button.dart';
import 'package:demo_application/core/componets/custom_logo.dart';
import 'package:demo_application/core/componets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() {
    return _SignupScreen();
  }
}

class _SignupScreen extends State<SignupScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController userName = TextEditingController();
   GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListView(children: [
            Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const CustomLogo(),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Signup',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'signup to continue Using The App',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[400]),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('username'),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                      validator: (vale) {
                        if (vale == '') {
                          return 'please write your user';
                        } else {
                          return null;
                        }
                      },
                      title: 'please Enter your username',
                      controller: userName),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Email'),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                      validator: (vale) {
                        if (vale == '') {
                          return 'please write your email';
                        } else {
                          return null;
                        }
                      },
                      title: 'please Enter your Email',
                      controller: email),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('password'),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                      validator: (vale) {
                        if (vale == '') {
                          return 'please write your password';
                        } else {
                          return null;
                        }
                      },
                      title: 'Please Enter your Password',
                      controller: password),
                  const SizedBox(
                    height: 14,
                  ),
                  const Align(
                    alignment: Alignment.topRight,
                    child: Text('Forget Password'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
              text: 'Signup',
              onPressed: () async {
              if(formState.currentState!.validate()){
                  try {
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email.text,
                    password: password.text,
                  );
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
                  Navigator.of(context).pushReplacementNamed('login');
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                  }
                } catch (e) {
                  print('===========================$e');
                }
              }
              else{
                return null ;
              }
              },
            ),
            const SizedBox(
              height: 18,
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
              },
              child: const Center(
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: " Have An Account?  "),
                  TextSpan(
                      text: 'Login', style: TextStyle(color: Colors.orange))
                ])),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
