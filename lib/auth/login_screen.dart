import 'dart:developer';

import 'package:demo_application/core/componets/custom_button.dart';
import 'package:demo_application/core/componets/custom_logo.dart';
import 'package:demo_application/core/componets/custom_text_form_field.dart';
import 'package:demo_application/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isloading=false;
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
     

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    
    // Obtain the auth details from the request
   
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
        

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:isloading?const Center(child: CircularProgressIndicator(),): SafeArea(
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
                    'Login',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Login to continue Using The App',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[400]),
                  ),
                  const SizedBox(
                    height: 30,
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
                  InkWell(
                    onTap: () async {
                      if (email.text == '') {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('not invalid'),
                            content: const Text(' please write your email'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('ok'))
                            ],
                          ),
                        );
                        return;
                      }

                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email.text);
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('success'),
                          content:
                              const Text('the link is sent in your e-mail'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('ok'))
                          ],
                        ),
                      );
                    },
                    child: const Align(
                      alignment: Alignment.topRight,
                      child: Text('Forget Password'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
                text: 'Login',
                onPressed: () async {
                  if (formState.currentState!.validate()) {
                    try {
                      isloading=true;
                      setState(() {
                        
                      });
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email.text, password: password.text);
                              isloading=false;
                              setState(() {
                                
                              });

                      if (credential.user!.emailVerified) {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) =>const Home()));
                      } else {}
                    } on FirebaseAuthException catch (e) {
                       isloading=false;
                              setState(() {
                                
                              });
                      
                        print('object');
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('failed'),
                            content: const Text(
                                'No user found for that email or Wrong password provided for that user'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('ok'))
                            ],
                          ),
                        );
                      
                    }
                  } else {
                    print('not valid');
                  }
                }),
            const SizedBox(
              height: 18,
            ),
            MaterialButton(
              height: 40,
              onPressed: signInWithGoogle,
              color: Colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign in With Google',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    'assets/images/4.png',
                    width: 40,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('signup');
              },
              child: const Center(
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: "Don't Have An Account?  "),
                  TextSpan(
                      text: 'Register', style: TextStyle(color: Colors.orange))
                ])),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
