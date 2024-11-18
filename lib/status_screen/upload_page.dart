import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/Auth/Service/constant.dart';
import '/Auth/Service/database.dart';
import 'package:uuid/uuid.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? file;
  bool uploading = false;
  String postId = const Uuid().v4();
  final ImagePicker _picker = ImagePicker();
  TextEditingController descriptionTextEditingController =
      TextEditingController();

  Future<void> pickImageFromGallery() async {
    Navigator.pop(context);
    final XFile? imagefile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 680,
        maxWidth: 970,
        imageQuality: 75);

    setState(() {
      file = imagefile != null ? File(imagefile.path) : null;
      print("File path: ${file?.path}");
      print("File exists: ${file?.existsSync()}");
    });
  }

  Future<void> captureImageWithCamera() async {
    Navigator.pop(context);
    final XFile? imagefile = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 680,
        maxWidth: 970,
        imageQuality: 75);
    setState(() {
      file = imagefile != null ? File(imagefile.path) : null;
    });
  }

  void close() {
    Navigator.pop(context);
  }

  void takeImage(BuildContext mContext) {
    showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            "Bài đăng mới",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: captureImageWithCamera,
              child:
                  const Text("Chụp ảnh", style: TextStyle(color: Colors.black)),
            ),
            SimpleDialogOption(
              onPressed: pickImageFromGallery,
              child: const Text("Chọn ảnh từ thư viện",
                  style: TextStyle(color: Colors.black)),
            ),
            SimpleDialogOption(
              onPressed: close,
              child:
                  const Text("Hủy bỏ", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  Widget displayUploadScreen() {
    return Container(
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.add_photo_alternate, color: Colors.blue, size: 150),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () => takeImage(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.0),
                ),
                backgroundColor: Colors.green,
              ),
              child: const Text(
                "Upload Image",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void removeImage() {
    setState(() {
      file = null;
    });
  }

  Future<String> uploadImage(File imageFile, String postId) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child("post_$postId.jpg");

      UploadTask uploadTask = storageRef.putFile(imageFile);

      TaskSnapshot storageSnap = await uploadTask.whenComplete(() => null);

      if (storageSnap.state == TaskState.success) {
        String downloadUrl = await storageSnap.ref.getDownloadURL();
        return downloadUrl;
      }
    } catch (e) {
      throw Exception("Upload failed: ${e.toString()}");
    }
    return "";
  }

  Future<void> createPostInFireStore({
    required String mediaUrl,
    required String description,
    required int time,
  }) async {
    await postsRef
        .doc(Constants.myEmail)
        .collection("userPosts")
        .doc(postId)
        .set({
      "postId": postId,
      "ownerId": Constants.myEmail,
      "username": Constants.myEmail,
      "mediaUrl": mediaUrl,
      "description": description,
      "time": time,
      "likes": {},
    });
  }

  Future<void> controlUploadAndSave() async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn ảnh trước khi đăng")),
      );
      return;
    }

    setState(() {
      uploading = true;
    });

    String mediaUrl = await uploadImage(file!, postId);
    await createPostInFireStore(
      mediaUrl: mediaUrl,
      description: descriptionTextEditingController.text,
      time: DateTime.now().millisecondsSinceEpoch,
    );
    descriptionTextEditingController.clear();
    setState(() {
      file = null;
      uploading = false;
    });
  }

  Widget displayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: removeImage,
        ),
        title: const Text(
          "Bài đăng mới",
          style: TextStyle(
              fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          uploading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: Colors.blue),
                )
              : TextButton(
                  onPressed: controlUploadAndSave,
                  child: Text(
                    "Đăng",
                    style: TextStyle(
                      color: uploading ? Colors.grey : Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          if (file != null)
            SizedBox(
              height: 230.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(file!),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          if (file != null) const SizedBox(height: 12.0),
          ListTile(
            title: TextFormField(
              style: const TextStyle(color: Colors.black),
              controller: descriptionTextEditingController,
              maxLines: 7,
              decoration: InputDecoration(
                hintText: "Cảm xúc của bạn hôm nay như thế nào?",
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? displayUploadScreen() : displayUploadFormScreen();
  }
}
