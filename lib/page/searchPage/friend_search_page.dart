import 'package:flutter/material.dart';
import 'package:flutter_sns/page/searchPage/searchPageHeader.dart';
import '../../design.dart';
import 'follow_fn.dart';

class FriendSearchPage extends StatefulWidget {
  const FriendSearchPage({
    super.key,
    required this.name,
    required this.id,
    required this.friendList,
    required this.recommendFriendList,
  });

  final String? name;
  final int? id;
  final List? friendList;
  final List? recommendFriendList;

  @override
  State<FriendSearchPage> createState() => _FriendSearchPageState();
}

class _FriendSearchPageState extends State<FriendSearchPage> {
  late String? name = widget.name;
  late int? id = widget.id;
  late List? friendList = widget.friendList;
  late List? recommendFriendList = widget.recommendFriendList;

  Future recommendFetch() async {
    return recommendFriendList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$name",
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () async {
            Navigator.pushNamed(context, '/home');
          },
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: 820,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 100,
                child: searchHeader(context, name: name),
              ),
              SizedBox(
                width: double.infinity,
                height: 720,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      child: SizedBox(
                        width: double.infinity,
                        height: 720,
                        child: SizedBox(
                          width: double.infinity,
                          height: 30,
                          child: recommendFriend(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget recommendFriend() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int i = 0; i < recommendFriendList!.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 10),
                      child: Image.asset(
                        recommendFriendList![i]["userIcon"],
                        height: 35,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 13),
                      child: Text(
                        recommendFriendList![i]["name"],
                        style: POST_NAME,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 150, top: 5),
                      child: SizedBox(
                        width: 140,
                        height: 40,
                        child: ElevatedButton(
                          style: followBtn,
                          onPressed: () {
                            follow(
                                userId: recommendFriendList![i]["id"],
                                context: context);
                          },
                          child: const Text(
                            "팔로우하기",
                            style: LOGIN_FONT,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          for (int i = 0; i < friendList!.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 10),
                      child: Image.asset(
                        friendList![i]["userIcon"],
                        height: 35,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 13),
                      child: Text(
                        friendList![i]["name"],
                        style: POST_NAME,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 150, top: 5),
                      child: SizedBox(
                        width: 140,
                        height: 40,
                        child: ElevatedButton(
                          style: unFollowBtn,
                          onPressed: () {
                            follow(
                                userId: friendList![i]['id'], context: context);

                            print(friendList![i]['id']);
                          },
                          child: const Text(
                            "팔로우취소",
                            style: LOGIN_FONT,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}