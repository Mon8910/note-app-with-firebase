import 'dart:io';
import 'package:path/path.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  const PickImage({super.key});
  @override
  State<PickImage> createState() {
    return _PickImage();
  }
}

class _PickImage extends State<PickImage> {
  File? file;
  String? url;
  getImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
// final XFile? image = await picker.pickImage(source: ImageSource.gallery);
// Capture a photo.
    final XFile? imageCamera =
        await picker.pickImage(source: ImageSource.camera);
        if(imageCamera !=null){
           file = File(imageCamera!.path);
           var baseImage= basename(imageCamera!.path);
           var refStorage=FirebaseStorage.instance.ref(baseImage);
           await refStorage.putFile(file!);
            url=await refStorage.getDownloadURL();

        }
    
    setState(() {});
// Pick a video.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: 
              ()async{
              await  getImage();
              }
            ,
            child: Text('camera'),
          ),
          if (url != null) Image.network(url!,height: 100,width: 100,fit: BoxFit.fill,)
        ],
      )),
    );
  }
}
