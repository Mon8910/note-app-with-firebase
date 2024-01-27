import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_application/home.dart';
import 'package:demo_application/note/note_add.dart';
import 'package:demo_application/note/note_update.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key, required this.uid});
  final String uid;
  @override
  State<NoteView> createState() {
    return _NoteView();
  }
}

class _NoteView extends State<NoteView> {
  List<QueryDocumentSnapshot> data = [];
  bool isloading = true;
  get() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.uid)
        .collection('note')
        .get();

    data.addAll(querySnapshot.docs);
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NoteAdd(
                    id: widget.uid,
                  )));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Note Page'),
        actions: [
          IconButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();

                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('login', (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: WillPopScope(
          child: isloading == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisExtent: 160),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onDoubleTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete'),
                            content: const Text('are you sure'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('categories')
                                        .doc(widget.uid)
                                        .collection('note')
                                        .doc(data[index].id)
                                        .delete();
                                         if(data[index]['url'] != 'none'){
                                          FirebaseStorage.instance.refFromURL( data[index]['url'] ).delete();
                                         }


                                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NoteView(uid: widget.uid)));
                                  },
                                  child: const Text('delete')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('cancel'))
                            ],
                          ),
                        );
                      },
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NoteUpdate(
                                noteId: data[index].id,
                                oldName: data[index]['note'],
                                categoryId: widget.uid)));
                      },
                      child: Card(
                        color: Colors.grey[100],
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [Text('${data[index]['note']}'),
                            SizedBox(height: 10,),
                            if(data[index]['url'] != 'none')
                           Image.network('${data[index]['url']}',height: 100,)
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
          onWillPop: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (contex) => const Home()));
            return Future.value(false);
          }),
    );
  }
}
