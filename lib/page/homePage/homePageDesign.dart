import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sns/page/homePage/comment_page.dart';
import 'package:flutter_sns/page/viewDetailPage/view_detail_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../design.dart';
import '../myPage/my_page.dart';
import 'comment.dart';
import 'like_fn.dart';

class HomaPageDesign extends StatefulWidget {
  const HomaPageDesign({
    super.key,
  });

  @override
  State<HomaPageDesign> createState() => _HomaPageDesignState();
}

class _HomaPageDesignState extends State<HomaPageDesign> {
  List<dynamic> data = [];
  final int pageCount = 3;

  List<dynamic> likeDataList = [];
  List<dynamic> postDataList = [];
  List<bool> imgList = [];

  @override
  void initState() {
    super.initState();
    _getLikeImg(); // 함수를 initState에서 호출합니다.
    _fetch();
  }

  void _getLikeImg() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt("id");
    int count = 0;

    var likeData =
        await http.get(Uri.parse("http://localhost:4000/getLike/$id"));
    var postData =
        await http.get(Uri.parse("http://localhost:4000/getOnlyPostList"));

    likeDataList = json.decode(likeData.body);
    postDataList = json.decode(postData.body);

    for (int i = 0; i < postDataList.length; i++) {
      for (int j = 0; j < likeDataList.length; j++) {
        if (postDataList[i]["id"] == likeDataList[j]["post_id"]) {
          count++;
        }
      }
      if (count != 0)
        imgList.add(true);
      else
        imgList.add(false);
      count = 0;
    }

    print(imgList);
  }

  @override
  final PageController pageController = PageController(
    // 먼저 보여줄 페이지
    // initialPage: 10, = 10페이지를 먼저 보여줌
    initialPage: 0,
    // 보여지는 화면의 width크기를 뜻한다.
    viewportFraction: 1.0,
  );

  void _fetch() async {
    var res = await http.get(Uri.parse("http://localhost:4000/postList"));

    if (res.statusCode == 200) {
      setState(() {
        data = json.decode(res.body);
      });
    }

    print(data[0].length);

    return json.decode(res.body);
  }

  @override
  Widget build(BuildContext context) {
    if (data.length == 0) return const Center(child: Text("loading!!"));
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < imgList.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 700,
                  child: Column(
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
                                      builder: (context) => MyPage(name: data[0][i]["name"], id: data[0][i]["userId"]),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  '${data[0][i]["userIcon"]}',

                                  // width와 height는 원본 소스 이미지(주어지는 이미지)의 비율에 맞추어 지정하는게 좋음
                                  // 비례식 x : y = a : b
                                  width: 35, // image 16:9 = 0.57...
                                  height: 35,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "${data[0][i]['name']}",
                                style: POST_NAME,
                              ),
                            ),
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
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                      pageId: data[0][i]["id"],
                                      id: data[0][i]["userId"],
                                    ),
                                  ),
                                );
                              },
                              child: Image.asset(
                                '${data[1][i]["value${index + 1}"]}',

                                // width와 height는 원본 소스 이미지(주어지는 이미지)의 비율에 맞추어 지정하는게 좋음
                                // 비례식 x : y = a : b
                                width: 35, // image 16:9 = 0.57...
                                height: 35,
                                fit: BoxFit.cover,
                              ),
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
                                  int postId = data[0][i]["id"];
                                  int? likeNum = data[0][i]["likeNum"];
                                  like(postId: postId, likeNum: likeNum);
                                },
                                child: Image.asset(
                                  // 'assets/images/heart_red.png',
                                  imgList[i]
                                      ? 'assets/images/heart_red.png'
                                      : 'assets/images/heart_black.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 13),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CommentPage(
                                        id: data[0][i]["id"].toString(),
                                        comment: '',
                                      ),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  'assets/images/comment.png',

                                  // width와 height는 원본 소스 이미지(주어지는 이미지)의 비율에 맞추어 지정하는게 좋음
                                  // 비례식 x : y = a : b
                                  width: 32, // image 16:9 = 0.57...
                                  height: 32,
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
                                  "해당 게시글을 ${data[0][i]["likeNum"]}명이 좋아합니다.",
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
                                      "${data[0][i]["name"]}",
                                      style: POST_NAME,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      "${data[0][i]["text"]}",
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
                                  "${data[0][i]["date"]}",
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
                        height: 150,
                        child: PostCommentPage(
                          id: data[0][i]["id"],
                          comment: '',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
