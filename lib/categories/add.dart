import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_application/core/componets/custom_button.dart';
import 'package:demo_application/core/componets/custom_text_add.dart';
import 'package:demo_application/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});
  @override
  State<AddScreen> createState() {
    return _AddScreen();
  }
}

class _AddScreen extends State<AddScreen> {
  TextEditingController addText = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  void dispose() {
    addText.dispose();
    super.dispose();
  }

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  // create categories in database
  addCategory() async {
    if (formState.currentState!.validate()) {
      try {
        DocumentReference response = await categories.add(
          {'name': addText.text, 'id': FirebaseAuth.instance.currentUser!.uid},
        );
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamedAndRemoveUntil('home',(route) => false);
        print('the value is add');
      } catch (e) {
        print('Error $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: Form(
        key: formState,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: CustomTextAdd(
                title: 'add Name',
                controller: addText,
                validator: (val) {
                  if (val == '') {
                    return 'please enter the name';
                  }
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomButton(text: 'Add', onPressed: addCategory)
          ],
        ),
      ),
    );
  }
}
