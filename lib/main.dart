import 'package:flutter/material.dart';
import 'package:flutter_sns/page/homePage/comment_page.dart';
import 'package:flutter_sns/page/homePage/homePage.dart';
import 'package:flutter_sns/page/myPage/my_page.dart';
import 'package:flutter_sns/page/postPage/post_page.dart';
import 'package:flutter_sns/page/searchPage/friend_search_page.dart';
import 'package:flutter_sns/page/searchPage/post_search_page.dart';
import 'package:flutter_sns/page/updatePage/post_update.dart';
import 'package:flutter_sns/page/viewDetailPage/view_detail_page.dart';
import 'package:flutter_sns/sign/sign.dart';
import 'login/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "flutter_note",
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const LoginPage(loginId: '', loginPw: ''),
        '/sign': (BuildContext context) => const SignPage(signId: '', signPw: '', signName: ''),
        '/home': (BuildContext context) => const HomePage(),
        '/myPage': (BuildContext context) => const MyPage(name: '', id: null,),
        '/postPage': (BuildContext context) => const PostPage(),
        '/commentPage': (BuildContext context) => const CommentPage(id: "", comment: '',),
        '/friendSearchPage': (BuildContext context) => const FriendSearchPage(name: '', id: null, friendList: [], recommendFriendList: [],),
        '/postSearchPage': (BuildContext context) => const PostSearchPage(name: '',),
        '/detailPage': (BuildContext context) => const DetailPage(pageId: 0, id: null,),
        '/updatePage': (BuildContext context) => const PostUpdatePage(pageId: 0,),
      },
    );
  }
}