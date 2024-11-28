import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:zalo/Auth/Service/constant.dart';
import 'package:zalo/Auth/Service/database.dart';
import 'package:zalo/home_screen/home_screen.dart';
import 'package:zalo/status_screen/status_screen.dart';
import 'package:zalo/widgets/common_widget.dart';

class PostContent extends StatefulWidget {
  @override
  _PostContentState createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  int selectedButton = -1;
  bool emojiShowing = false;
  File? file;
  String mediaUrl = "";
  bool uploading = false;
  String postId = const Uuid().v8();
  TextEditingController contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    contentController.addListener(() {});
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  void _onIconButtonPressed(int buttonIndex) {
    if (mounted) {
      setState(() {
        if (selectedButton == buttonIndex) {
          selectedButton = -1;
        } else {
          selectedButton = buttonIndex;
        }
      });
    }
  }

  _onEmojiSelected(Emoji emoji) {
    contentController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: contentController.text.length));
  }

  _onBackspacePressed() {
    contentController
      ..text = contentController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: contentController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildPostInputField(),
            _buildBottomBar(),
            selectedButton == 0
                ? _buildEmojiPicker()
                : selectedButton == 1
                    ? _buildUploadImage()
                    : const SizedBox.shrink(),
            if (uploading) buildLoadingIndicator()
          ],
        ));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.grey.shade200,
      elevation: 0,
      title: const Text(
        "Bài đăng mới",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        ),
      ),
      actions: [_buildRightAppBar()],
    );
  }

  Widget _buildRightAppBar() {
    return TextButton(
        onPressed: () => {
              _createPostInFireStore(
                  postId: postId,
                  mediaUrl: mediaUrl,
                  description: contentController.text,
                  time: DateTime.now().millisecondsSinceEpoch)
            },
        child: Text(
          "Đăng",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: contentController.text.isNotEmpty
                  ? Colors.blue
                  : Colors.grey),
        ));
  }

  Widget _buildPostInputField() {
    return Expanded(
      child: TextFormField(
        controller: contentController,
        textInputAction: TextInputAction.newline,
        expands: true,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 10, top: 10),
        ),
        autofocus: true,
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            border: Border.symmetric(
                horizontal: BorderSide(width: 1, color: Colors.grey.shade100))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () => {_onIconButtonPressed(0)},
                    icon: const Icon(Icons.emoji_emotions_outlined))
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 15),
                IconButton(
                    onPressed: () => {_onIconButtonPressed(1)},
                    icon: const Icon(Icons.image_outlined)),
                const SizedBox(width: 15),
                IconButton(
                    onPressed: () => {_onIconButtonPressed(2)},
                    icon: const Icon(Icons.video_file_outlined)),
                const SizedBox(width: 15),
                IconButton(
                    onPressed: () => {_onIconButtonPressed(3)},
                    icon: const Icon(Icons.link_outlined)),
                const SizedBox(width: 15),
                IconButton(
                    onPressed: () => {_onIconButtonPressed(4)},
                    icon: const Icon(Icons.location_pin))
              ],
            )
          ],
        ));
  }

  Widget _buildUploadImage() {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, i) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              if (i == 0 && index == 0) {
                return Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.grey.shade200,
                    child: IconButton(
                      hoverColor: Colors.grey.shade200,
                      splashRadius: 1,
                      splashColor: Colors.transparent,
                      icon: const Icon(Icons.camera_alt, color: Colors.blue),
                      onPressed: () {
                        _createMediaUrl();
                      },
                    ),
                  ),
                );
              } else {
                return Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    child: Image.network(
                      'https://plus.unsplash.com/premium_photo-1664474619075-644dd191935f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aW1hZ2V8ZW58MHx8MHx8fDA%3D',
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
            }),
          );
        },
      ),
    );
  }

  Widget _buildEmojiPicker() {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: (Category? category, Emoji emoji) {
          _onEmojiSelected(emoji);
        },
        onBackspacePressed: _onBackspacePressed,
        config: const Config(
            height: 256,
            emojiTextStyle: TextStyle(),
            viewOrderConfig: ViewOrderConfig(
              top: EmojiPickerItem.categoryBar,
              middle: EmojiPickerItem.emojiView,
              bottom: EmojiPickerItem.searchBar,
            ),
            skinToneConfig: SkinToneConfig(),
            categoryViewConfig: CategoryViewConfig(),
            bottomActionBarConfig: BottomActionBarConfig(),
            searchViewConfig: SearchViewConfig(),
            checkPlatformCompatibility: true),
      ),
    );
  }

  Future<void> _captureWithCamera() async {
    XFile? imageFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 680,
        maxWidth: 970,
        imageQuality: 75);

    setState(() {
      if (imageFile != null) {
        file = File(imageFile.path);
        print(file!.path);
      }

    });
  }

  Future<String> _processingImage() async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child("post_$postId.jpg");

      final TaskSnapshot snapshot = await storageRef.putFile(file!);

      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception("Upload failed: ${e.toString()}");
    }
  }

  Future<void> _createMediaUrl() async {
    await _captureWithCamera();

    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn ảnh trước khi đăng")),
      );
      return;
    }

    // if (mounted) {
    //   setState(() {
    //     uploading = false;
    //   });
    // }

    try {
      mediaUrl = await _processingImage();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã xảy ra lỗi: $e")),
      );
    } finally {}
  }

  Future<void> _createPostInFireStore({
    required String postId,
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đăng bài thành công!")),
    );
  }
}
