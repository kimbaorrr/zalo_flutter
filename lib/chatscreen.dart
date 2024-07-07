import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp/Auth/Service/auth_service.dart';
import 'package:provider/provider.dart';
import 'firebaseHelper.dart';

var loginUser = FirebaseAuth.instance.currentUser;

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Service service = Service();

  final storeMessage = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  TextEditingController msg = TextEditingController();

  getCurrenrUser() {
    final user = auth.currentUser;
    if (user != null) {
      loginUser = user;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrenrUser();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context); //NDL Long add
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                await authService.signOut();
              },
              icon: Icon(Icons.logout))
        ],
        title: Text(loginUser!.email.toString()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
                height: 500,
                child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    reverse: true,
                    child: ShowMessages())),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.blue, width: 0.2))),
                  child: TextField(
                    controller: msg,
                    decoration: InputDecoration(hintText: "Enter Message ..."),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (msg.text.isNotEmpty) {
                      storeMessage.collection("Messages").doc().set({
                        "messages": msg.text.trim(),
                        "user": loginUser!.email.toString(),
                        "time": DateTime.now()
                      });
                      msg.clear();
                    }
                    msg.clear();
                  },
                  icon: Icon(
                    Icons.send,
                    color: Colors.teal,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class ShowMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Messages")
          .orderBy("time")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            primary: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, i) {
              QueryDocumentSnapshot x = snapshot.data!.docs[i];
              return ListTile(
                title: Column(
                  crossAxisAlignment: loginUser!.email == x["user"]
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        color: loginUser!.email == x["user"]
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.amber.withOpacity(0.4),
                        child: Text(x["messages"])),
                  ],
                ),
              );
            });
      },
    );
  }
}
