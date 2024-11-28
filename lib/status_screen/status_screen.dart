import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zalo/widgets/common_widget.dart';
import '/Auth/Service/constant.dart';
import '/Auth/Service/database.dart';
import '/Auth/modals/user.dart';
import 'create_post.dart';
import 'post_container.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  late final DatabaseMethods db;
  Users? user;
  late Future<List<PostContainer>> futurePosts;

  @override
  void initState() {
    super.initState();
    db = DatabaseMethods();
    futurePosts = getPosts();
  }

  Future<List<PostContainer>> getPosts() async {
    try {
      QuerySnapshot snapshot = await postsRef
          .doc(Constants.myEmail)
          .collection("userPosts")
          .orderBy("time", descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PostContainer.fromDocument(doc: doc))
          .toList();
    } catch (e) {
      debugPrint("Error fetching posts: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: CreatePostContainer(),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder<List<PostContainer>>(
                future: futurePosts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: buildLoadingIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error loading posts."),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshot.data!.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 5),
                      itemBuilder: (context, index) => snapshot.data![index],
                    );
                  } else {
                    return const Center(
                      child: Text("Không có bài đăng nào !"),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
