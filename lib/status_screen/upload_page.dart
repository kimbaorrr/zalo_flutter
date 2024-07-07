import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_myapp/Auth/Service/constant.dart';
import 'package:flutter_myapp/Auth/Service/database.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? file;
  bool uploading = false;
  String postId = Uuid().v4();
  final ImagePicker _picker = ImagePicker();
  TextEditingController descriptionTextEditingController =
      TextEditingController();

  pickImageFromGallery() async {
    Navigator.pop(context);
    XFile? imagefile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      this.file = File(imagefile!.path);
    });
  }

  captureImageWithCamera() async {
    Navigator.pop(context);
    XFile? imagefile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      file = File(imagefile!.path);
    });
  }

  close() {
    Navigator.pop(context);
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "New Post",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  "Capture Image with Camera",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  "Select Image from Gallery",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: close,
              ),
            ],
          );
        });
  }

  displayUploadScreen() {
    return Container(
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.add_photo_alternate, color: Colors.blue, size: 150),
          Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () => takeImage(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0),
                  ),
                  primary: Colors.green,
                ),
                child: Text(
                  "Upload Image",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              )),
        ],
      ),
    );
  }

  removeImage() {
    setState(() {
      file = null;
    });
  }

  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(file!.readAsBytesSync())!;
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 85));
    setState(() {
      file = compressedImageFile as File?;
    });
  }

  Future<String> uploadImage(imageFile) async {
    UploadTask uploadTask =
        storageRef.child("post_$postId.jpg").putFile(imageFile!);
    TaskSnapshot storageSnap = await uploadTask.whenComplete(() => null);
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  createPostInFireStore(
      {required String mediaUrl,
      required String description,
      required int time}) {
    postsRef.doc(Constants.myEmail).collection("userPosts").doc(postId).set({
      "postId": postId,
      "ownerId": Constants.myEmail,
      "username": Constants.myEmail,
      "mediaUrl": mediaUrl,
      "description": description,
      "time": time,
      "likes": {},
    });
  }

  controlUploadAndSave() async {
    {
      setState(() {
        uploading = true;
      });
      await compressingPhoto();
      String mediaUrl = await uploadImage(file);
      createPostInFireStore(
          mediaUrl: mediaUrl,
          description: descriptionTextEditingController.text,
          time: DateTime.now().millisecondsSinceEpoch);
      descriptionTextEditingController.clear();
      setState(() {
        file = null;
        uploading = false;
      });
    }
  }

  displayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: removeImage),
        title: Text(
          "New Post",
          style: TextStyle(
              fontSize: 24.0, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: uploading ? null : () => controlUploadAndSave(),
            child: Text(
              "Đăng",
              style: TextStyle(
                color: uploading ? Colors.grey : Colors.lightBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(file!), fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
          ),
          ListTile(
              leading: CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(
                    'https://scr.vn/wp-content/uploads/2020/08/%E1%BA%A2nh-hot-girl-l%C3%A0m-avt.jpg'),
              ),
              title: Container(
                width: 250.0,
                child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  controller: descriptionTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Cảm xúc của bạn hôm nay như thế nào?",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? displayUploadScreen() : displayUploadFormScreen();
    throw UnimplementedError();
  }
}
