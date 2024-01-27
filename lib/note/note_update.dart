import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_application/core/componets/custom_button.dart';
import 'package:demo_application/core/componets/custom_text_add.dart';
import 'package:demo_application/note/note_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NoteUpdate extends StatefulWidget {
  const NoteUpdate({super.key, required this.noteId,required this.oldName, required this.categoryId});
  final String noteId;
  final String oldName;
  final String categoryId;
  @override
  State<NoteUpdate> createState() {
    return _NoteUpdate();
  }
}

class _NoteUpdate extends State<NoteUpdate> {
  TextEditingController add = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  void dispose() {
    add.dispose();
    super.dispose();
  }

  // create categories in database
  addNote() async {
    CollectionReference categories = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection('note');
    if (formState.currentState!.validate()) {
      try {
       await categories.doc(widget.noteId).update(
          {
            'note': add.text,
          },
        );
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(builder: (count)=>NoteView(uid: widget.categoryId)));
        print('the value is add');
      } catch (e) {
        print('Error $e');
      }
    }
  }
  @override
  void initState() {
   add.text=widget.oldName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Note'),
      ),
      body: Form(
        key: formState,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: CustomTextAdd(
                title: 'Update Name',
                controller: add,
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
            CustomButton(text: 'Update', onPressed: addNote)
          ],
        ),
      ),
    );
  }
}
