import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp/Auth/Service/constant.dart';
import 'package:flutter_myapp/Auth/Service/database.dart';
import 'package:flutter_myapp/Auth/modals/user.dart';
import 'createpost.dart';
import 'post_container.dart';

class Diary extends StatefulWidget {
  @override
  _DiaryState createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  DatabaseMethods? db;
  Users? user;
  bool isLoading = false;
  List<PostContainer> posts = [];
  @override
  void initState() {
    super.initState();
    getPosts();
  }

  getPosts() async {
    // setState(() {
    //   isLoading = true;
    // });
    QuerySnapshot snapshot = await postsRef
        .doc("0912345678")
        .collection("userPosts")
        .orderBy("time", descending: true)
        .get();
    //posts = snapshot.docs.map((doc) => PostContainer.fromDocument(doc: doc)).toList();

    setState(() {
      //isLoading = false;
      posts = snapshot.docs
          .map((doc) => PostContainer.fromDocument(doc: doc))
          .toList();
      print(posts);
    });
  }

  buildPosts() {
    // if(isLoading){
    //   return const CircularProgressIndicator(color: Colors.black,);
    // }
    return Column(
      children: posts,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: CreatePostContainer(),
            ),
            SliverToBoxAdapter(
              // child: ListView.separated(
              //   shrinkWrap: true,
              //   primary: false,
              //   itemCount: 20,
              //   separatorBuilder: (context, index) => const SizedBox(height: 5,),
              //   itemBuilder:(context, index) => PostContainer(
              //     caption: 'Hello App',
              //     name: Constants.myName,
              //     time_ago: '1 hour ago',
              //     imageUrl: 'https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg',
              //     avatarUrl: 'https://scr.vn/wp-content/uploads/2020/08/%E1%BA%A2nh-hot-girl-l%C3%A0m-avt.jpg',
              //   ),
              // ),
              child: ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (BuildContext context, int index) {
                  return posts[index];
                },
                itemCount: posts.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
