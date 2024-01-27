import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_application/core/componets/custom_button.dart';
import 'package:demo_application/core/componets/custom_text_add.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.uid, required this.oldNmae});
  final String uid;
  final String oldNmae;
  @override
  State<EditScreen> createState() {
    return _EditScreen();
  }
}

class _EditScreen extends State<EditScreen> {
  TextEditingController editText = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  void dispose() {
    editText.dispose();
    super.dispose();
  }

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  // create categories in database
  editCategory() async {
    if (formState.currentState!.validate()) {
      try {
        await categories.doc(widget.uid).update({"name": editText.text});

        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
        print('the value is add');
      } catch (e) {
        print('Error $e');
      }
    }
  }
  @override
  void initState() {
    editText.text=widget.oldNmae;
    super.initState();
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
                controller: editText,
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
            CustomButton(text: 'Add', onPressed: editCategory)
          ],
        ),
      ),
    );
  }
}
