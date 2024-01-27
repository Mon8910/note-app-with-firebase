import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_application/core/componets/custom_button.dart';
import 'package:demo_application/core/componets/custom_text_add.dart';
import 'package:demo_application/note/note_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class NoteAdd extends StatefulWidget {
  const NoteAdd({super.key, required this.id});
  final String id;
  @override
  State<NoteAdd> createState() {
    return _NoteAdd();
  }
}

class _NoteAdd extends State<NoteAdd> {
  TextEditingController add = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  void dispose() {
    add.dispose();
    super.dispose();
  }

  // create categories in database
  addNote(context) async {
    CollectionReference categories = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.id)
        .collection('note');
    if (formState.currentState!.validate()) {
      try {
        DocumentReference response = await categories.add(
          {
            'note': add.text,
            'url':url ?? 'none'
          },
        );
        // ignore: use_build_context_synchronously
        Navigator.of( context ).push(
            MaterialPageRoute(builder: (count) => NoteView(uid: widget.id)));
        print('the value is add');
      } catch (e) {
        print('Error $e');
      }
    }
  }

  File? file;
  String? url;
  getImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
// final XFile? image = await picker.pickImage(source: ImageSource.gallery);
// Capture a photo.
    final XFile? imageCamera =
        await picker.pickImage(source: ImageSource.camera);
    if (imageCamera != null) {
      file = File(imageCamera!.path);
      var baseImage = basename(imageCamera!.path);
      var refStorage = FirebaseStorage.instance.ref(baseImage);
      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();
    }

    setState(() {});
// Pick a video.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Form(
        key: formState,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: CustomTextAdd(
                title: 'add Name',
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
            CustomButtonUpload(
                text: 'Upload',
                onPressed: ()  {
                   getImage();
                },
                isselected: url == null ? false : true),
            const SizedBox(
              height: 10,
            ),
            CustomButton(text: 'Add', onPressed: (){
              addNote(context);
            })
          ],
        ),
      ),
    );
  }
}
