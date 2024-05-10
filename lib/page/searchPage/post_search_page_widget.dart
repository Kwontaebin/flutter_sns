import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_sns/page/searchPage/searchPageHeader.dart';

import '../viewDetailPage/view_detail_page.dart';

class SearchPostPageWidget extends StatefulWidget {
  const SearchPostPageWidget({
    super.key,
    required this.name,
  });

  final String? name;

  @override
  State<SearchPostPageWidget> createState() => _SearchPostPageWidgetState();
}

class _SearchPostPageWidgetState extends State<SearchPostPageWidget> {
  late String? name = widget.name;
  String text = "";
  List<dynamic> data = [];
  final int pageCount = 3;

  @override
  final PageController pageController = PageController(
    // 먼저 보여줄 페이지
    // initialPage: 10, = 10페이지를 먼저 보여줌
    initialPage: 0,
    // 보여지는 화면의 width크기를 뜻한다.
    viewportFraction: 1.0,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              height: 60,
              child: TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "게시글을 검색하세요",
                  hintText: '게시글 입력',
                  suffixIcon: GestureDetector(
                    child: const Icon(
                      Icons.send,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    text = value;
                  });
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 600,
              child: FutureBuilder(
                future: searchPost(),
                builder: (context, snap) {
                  if (!snap.hasData)
                    return const Center(child: Text("검색 결과가 없습니다."));

                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 1.0, // 가로 간격
                          mainAxisSpacing: 1.0,
                          childAspectRatio: 0.8,
                        ),
                        children: [
                          for (int i = 0; i < data.length; i++)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(pageId: data[i]["id"], id:data[i]["userId"]),
                                  ),
                                );
                              },
                              child: Image.asset(
                                data[i]["img"][0],
                                width: 35,
                                height: 35,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (data.length == 0)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "게시글이 없습니다",
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> searchPost() async {
    var res = await http.get(Uri.parse("http://localhost:4000/searchPost/$text"));
    data = json.decode(res.body);
    return json.decode(res.body);
  }
}
