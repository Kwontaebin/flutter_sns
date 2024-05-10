import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sns/page/searchPage/post_search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../design.dart';
import 'friend_search_page.dart';
import 'package:http/http.dart' as http;

Widget searchHeader(BuildContext context, {String? name}) {
  List<dynamic> friendListId = []; // 해당 값의 id
  List<dynamic> friendList = [];
  List<dynamic> recommendFriendList = [];

  List<dynamic> followData = [];
  List<dynamic> userData = [];

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
       Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () async {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
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
          child: const Text(
            "친구 추천",
            style: SEARCH_FONT,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostSearchPage(name: name),
              ),
            );
          },
          child: const Text(
            "게시글 검색",
            style: SEARCH_FONT,
          ),
        ),
      ),
    ],
  );
}
