import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '/Auth/Service/constant.dart';
import '/Auth/Service/database.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;

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

  // Method to pick an image from the gallery
  Future<void> pickImageFromGallery() async {
    Navigator.pop(context);
    final XFile? imagefile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      file = imagefile != null ? File(imagefile.path) : null;
    });
  }

  // Method to capture an image with the camera
  Future<void> captureImageWithCamera() async {
    Navigator.pop(context);
    final XFile? imagefile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      file = imagefile != null ? File(imagefile.path) : null;
    });
  }

  // Close dialog
  void close() {
    Navigator.pop(context);
  }

  // Show dialog to pick or capture an image
  void takeImage(BuildContext mContext) {
    showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            "New Post",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: captureImageWithCamera,
              child: const Text("Capture Image with Camera",
                  style: TextStyle(color: Colors.black)),
            ),
            SimpleDialogOption(
              onPressed: pickImageFromGallery,
              child: const Text("Select Image from Gallery",
                  style: TextStyle(color: Colors.black)),
            ),
            SimpleDialogOption(
              onPressed: close,
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  // Display the screen when no image is selected
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

  // Remove the selected image
  void removeImage() {
    setState(() {
      file = null;
    });
  }

  // Compress the selected photo before uploading
  Future<void> compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(file!.readAsBytesSync())!;
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  // Upload image to Firebase Storage
  Future<String> uploadImage(File imageFile, String postId) async {
    try {
      // Tạo tham chiếu tới Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref().child("post_$postId.jpg");

      // Tải lên ảnh với UploadTask
      UploadTask uploadTask = storageRef.putFile(imageFile);

      // Lắng nghe khi hoàn thành tải lên
      TaskSnapshot storageSnap = await uploadTask.whenComplete(() => null);

      // Kiểm tra nếu có lỗi trong quá trình tải lên
      if (storageSnap.state == TaskState.success) {
        // Lấy URL tải xuống sau khi tải lên thành công
        String downloadUrl = await storageSnap.ref.getDownloadURL();
        return downloadUrl;
      } else {
        print("Upload failed: ${storageSnap.toString()}");
        return ''; // Trả về chuỗi rỗng nếu tải lên thất bại
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print("Error uploading image: $e");
      return ''; // Trả về chuỗi rỗng nếu có lỗi
    }
  }

  // Create a new post in Firestore
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

  // Control the upload and save process
  Future<void> controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });
    await compressingPhoto();
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

  // Display the form for uploading
  Widget displayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: removeImage,
        ),
        title: const Text(
          "New Post",
          style: TextStyle(
              fontSize: 24.0, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: uploading ? null : controlUploadAndSave,
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
                    ),
                  ),
                ),
              ),
            ),
          const Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.grey[200],
              backgroundImage: NetworkImage(Constants.myAvatar),
            ),
            title: TextFormField(
              style: const TextStyle(color: Colors.black),
              controller: descriptionTextEditingController,
              decoration: const InputDecoration(
                hintText: "Cảm xúc của bạn hôm nay như thế nào?",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
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
