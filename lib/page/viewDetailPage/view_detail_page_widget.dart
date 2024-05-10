import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sns/page/viewDetailPage/detail_page_comment.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../design.dart';
import '../homePage/like_fn.dart';
import '../myPage/my_page.dart';

class ViewDetailPageWidget extends StatefulWidget {
  const ViewDetailPageWidget({
    super.key,
    required this.pageId,
  });

  final int pageId;

  @override
  State<ViewDetailPageWidget> createState() => _ViewDetailPageWidgetState();
}

class _ViewDetailPageWidgetState extends State<ViewDetailPageWidget> {
  List<dynamic> data = [];
  List<dynamic> likeDataList = [];
  bool likeImg = false;
  late int pageId = widget.pageId;
  final int pageCount = 3;
  bool _functionExecuted = false;

  @override
  void initState() {
    super.initState();
    if (!_functionExecuted) {
      _getLikeImg(); // 함수를 initState에서 호출합니다.
      _functionExecuted = true;
    }

    fetch();
  }

  void _getLikeImg() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt("id");
    var likeData =
        await http.get(Uri.parse("http://localhost:4000/getLike/$id"));

    likeDataList = json.decode(likeData.body);

    for (int i = 0; i < likeDataList.length; i++) {
      if (likeDataList[i]["post_id"] == pageId) {
        likeImg = true;
      }
    }
  }

  @override
  final PageController pageController = PageController(
    // 먼저 보여줄 페이지
    // initialPage: 10, = 10페이지를 먼저 보여줌
    initialPage: 0,
    // 보여지는 화면의 width크기를 뜻한다.
    viewportFraction: 1.0,
  );

  void fetch() async {
    var res = await http
        .get(Uri.parse("http://localhost:4000/viewDetailPost/$pageId"));

    if (res.statusCode == 200) {
      setState(() {
        data = json.decode(res.body);
      });
    }

    return json.decode(res.body);
  }

  @override
  Widget build(BuildContext context) {
    if (data.length == 0) return const Center(child: Text("loading!!"));
    return SizedBox(
      width: double.infinity,
      height: 820,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyPage(
                              name: data[0]["name"], id: data[0]["userId"]),
                        ),
                      );
                    },
                    child: Image.asset(
                      data[0]["userIcon"],
                      width: 35, // image 16:9 = 0.57...
                      height: 35,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    data[0]["name"],
                    style: POST_NAME,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 350,
            child: PageView.builder(
              itemCount: pageCount,
              scrollDirection: Axis.horizontal,
              controller: pageController,
              physics: const BouncingScrollPhysics(),
              // 필수 - 목록의 갯수
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  '${data[0]["img"][index]}',
                  // width와 height는 원본 소스 이미지(주어지는 이미지)의 비율에 맞추어 지정하는게 좋음
                  // 비례식 x : y = a : b
                  width: 35, // image 16:9 = 0.57...
                  height: 35,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap: () async {
                      int postId = pageId;
                      int? likeNum = 0;
                      like(postId: postId, likeNum: likeNum);
                    },
                    child: Image.asset(
                      likeImg
                          ? 'assets/images/heart_red.png'
                          : 'assets/images/heart_black.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 33,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "해당 게시글을 ${data[0]["likeNum"]}명이 좋아합니다.",
                      style: POST_NAME,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 33,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "${data[0]["name"]}",
                          style: POST_NAME,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "${data[0]["text"]}",
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 33,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${data[0]["date"]}",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 250,
            child: DetailPageCommentPage(
              pageId: pageId,
            ),
          )
        ],
      ),
    );
  }
}
