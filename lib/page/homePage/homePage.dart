import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sns/page/postPage/post_page.dart';
import 'package:flutter_sns/page/searchPage/friend_search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../design.dart';
import 'package:http/http.dart' as http;
import '../myPage/my_page.dart';
import 'homePageDesign.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> friendListId = []; // 해당 값의 id
  List<dynamic> friendList = [];
  List<dynamic> recommendFriendList = [];

  List<dynamic> followData = [];
  List<dynamic> userData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar속 요소들의 색상
        elevation: 0,
        title: const Text(
          'Flutter',
          style: BASIC_FONT,
        ),

        centerTitle: true,
        // 텍스트 중앙 정렬

        leading: IconButton(
          icon: const Icon(Icons.grid_view_outlined),
          onPressed: () async {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            String? name = prefs.getString("name");
            int? id = prefs.getInt("id");

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyPage(name: name, id: id),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.post_add),
            onPressed: () {
              Navigator.pushNamed(context, "/postPage");
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              String? name = prefs.getString("name");
              int? id = prefs.getInt("id");
              int count = 0;

              var getFollowData = await http.get(Uri.parse("http://localhost:4000/getFollowList"));
              var userListData = await http.get(Uri.parse("http://localhost:4000/userList"));

              followData = json.decode(getFollowData.body);
              userData = json.decode(userListData.body);

              for (int i = 0; i < followData.length; i++) {
                if (followData[i]["my_id"] == id) {
                  friendListId.add(followData[i]["user_id"]);
                }
              }

              for (int i = 0; i < userData.length; i++) {
                for (int j = 0; j < friendListId.length; j++) {
                  if (userData[i]["id"] != friendListId[j]) {
                    count++;
                  }
                }

                if (count == friendListId.length) {
                  recommendFriendList.add(userData[i]);
                } else if(count != friendListId.length) {
                  friendList.add(userData[i]);
                }
                count = 0;
              }

              for(int i = 0; i < recommendFriendList.length; i++) {
                if(recommendFriendList[i]["id"] == id) {
                  recommendFriendList.remove(recommendFriendList[i]);
                }
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FriendSearchPage(name: name, id: id, friendList: friendList, recommendFriendList: recommendFriendList),
                ),
              );
            },
          ),
        ],
      ),
      body: const HomaPageDesign(),
    );
  }
}
