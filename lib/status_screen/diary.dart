import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/Auth/Service/constant.dart';
import '/Auth/Service/database.dart';
import '/Auth/modals/user.dart';
import 'createpost.dart';
import 'post_container.dart';

class Diary extends StatefulWidget {
  const Diary({super.key});

  @override
  _DiaryState createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  late final DatabaseMethods db; // Khởi tạo final
  Users? user; // Có thể null
  late Future<List<PostContainer>> futurePosts; // Sử dụng Future

  @override
  void initState() {
    super.initState();
    db = DatabaseMethods(); // Khởi tạo db
    futurePosts = getPosts(); // Lấy dữ liệu
  }

  Future<List<PostContainer>> getPosts() async {
    try {
      QuerySnapshot snapshot = await postsRef
          .doc(Constants.myEmail)
          .collection("userPosts")
          .orderBy("time", descending: true)
          .get();

      // Chuyển đổi dữ liệu Firestore thành danh sách PostContainer
      return snapshot.docs
          .map((doc) => PostContainer.fromDocument(doc: doc))
          .toList();
    } catch (e) {
      debugPrint("Error fetching posts: $e");
      return []; // Trả về danh sách rỗng nếu có lỗi
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
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    );
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
                      child: Text("No posts available."),
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
