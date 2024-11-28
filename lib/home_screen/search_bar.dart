import 'package:flutter/material.dart';
import 'package:zalo/Auth/Service/constant.dart';
import 'package:zalo/Auth/Service/database.dart';
import 'package:zalo/Auth/modals/user.dart';
import 'package:zalo/home_screen/user_card.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<Users> searchItem = listUsers;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(
            Icons.clear,
            color: Colors.black87,
          ))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Users> matchQuery = [];
    for (var i in searchItem) {
      if (i.name.toLowerCase().contains(query.toLowerCase()) ||
          i.email.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(i);
      }
    }
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      itemCount: matchQuery.length >= 5 ? 5 : matchQuery.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: 15,
      ),
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => UserCard(
                avatarUrl: Constants.myAvatar,
                userName: result.name,
                userEmail: result.email.replaceAll("@gmail.com", ""),
                isFriend: result.friends.contains(result.name),
              ),
            );
          },
          child: Row(
            children: [
              Flexible(
                  flex: 2,
                  child: SizedBox.fromSize(
                    size: const Size(60, 60),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(result.avatar),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.name,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.phone),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            result.email.replaceAll("@gmail.com", ''),
                            style: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Users> matchQuery = [];
    for (var i in searchItem) {
      if (i.name.toLowerCase().contains(query.toLowerCase()) ||
          i.email.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(i);
      }
    }
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      itemCount: matchQuery.length >= 5 ? 5 : matchQuery.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: 15,
      ),
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => UserCard(
                  avatarUrl: Constants.myAvatar,
                  userName: result.name,
                  userEmail: result.email.replaceAll("@gmail.com", ""),
                  isFriend: result.friends.contains(result.name)),
            );
          },
          child: Row(
            children: [
              Flexible(
                  flex: 2,
                  child: SizedBox.fromSize(
                    size: const Size(60, 60),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(result.avatar),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.name,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          result.email.replaceAll("@gmail.com", ''),
                          style: const TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
