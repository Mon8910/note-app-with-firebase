import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_application/categories/add.dart';
import 'package:demo_application/categories/edit.dart';
import 'package:demo_application/note/note_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() {
    return _Home();
  }
}

class _Home extends State<Home> {
  List<QueryDocumentSnapshot> data = [];
  bool isloading = true;
  get() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AddScreen()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Home Page'),
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
      body: isloading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 160),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NoteView(uid:data[index].id)));
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('warning'),
                        content: const Text('You can choose as you want'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('categories')
                                    .doc(data[index].id)
                                    .delete();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (builder) => const Home()));
                              },
                              child: const Text('ok')),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: ((context) => EditScreen(
                                        uid: data[index].id,
                                        oldNmae: data[index]['name']))));
                              },
                              child: const Text('edit'))
                        ],
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.grey[100],
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/folder.jpeg',
                            height: 100,
                          ),
                          Text('${data[index]['name']}')
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
