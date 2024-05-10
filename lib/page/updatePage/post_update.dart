import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_sns/design.dart';

class PostUpdatePage extends StatefulWidget {
  const PostUpdatePage({
    super.key,
    required this.pageId,
  });

  final int pageId;

  @override
  State<PostUpdatePage> createState() => _PostUpdatePageState();
}

class _PostUpdatePageState extends State<PostUpdatePage> {
  late int pageId = widget.pageId;
  List<dynamic> data = [];
  final int pageCount = 3;
  String text = "";

  @override
  final PageController pageController = PageController(
    // 먼저 보여줄 페이지
    // initialPage: 10, = 10페이지를 먼저 보여줌
    initialPage: 0,
    // 보여지는 화면의 width크기를 뜻한다.
    viewportFraction: 1.0,
  );

  Future fetch() async {
    // var res = await http.get(Uri.parse("http://192.168.1.106:4000/postList"));
    var res = await http.get(Uri.parse("http://localhost:4000/viewDetailPost/$pageId"));

    if (res.statusCode == 200) {
      setState(() {
        data = json.decode(res.body);
      });
    }

    return json.decode(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flutter",
          style: BASIC_FONT,
        ),
      ),

      body: FutureBuilder(
        future: fetch(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: Text("loading!!"));

          return SizedBox(
            width: double.infinity,
            height: 820,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
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
                        '${snap.data[0]["img"][index]}',
                        // width와 height는 원본 소스 이미지(주어지는 이미지)의 비율에 맞추어 지정하는게 좋음
                        // 비례식 x : y = a : b
                        width: 35, // image 16:9 = 0.57...
                        height: 35,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    initialValue: data[0]["text"].toString(),
                    onChanged: (value) {
                      setState(() {
                        text = data[0]["text"].toString();
                        text = value;
                      });
                    },
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: ElevatedButton(
                        style: updateBtn,
                        // ! Statefulwidget을 하지 않으면 setState를 사용하지 못한다.
                        // onPressed 누르면 데이터 전달하기
                        onPressed: () {
                          setState(() {
                            if (text == "") text = data[0]["text"].toString();
                            postUpdateFn();
                          });
                        },
                        child: const Text(
                          "수정하기",
                          style: UPDATE_DELETE_FONT,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }
      ),
    );
  }

  void postUpdateFn() async {
    print(text);
    print(data[0]["id"]);

    var url = Uri.parse("http://localhost:4000/PostUpdateText");
    var value = {"text": text, "id": data[0]["id"]};

    var res = await http.put(
      url,
      body: json.encode(value),
      headers: {"Content-Type": "application/json"},
    );

    if (res.statusCode == 200) print('POST 성공: ${res.body}'); Navigator.pop(context);
    if (res.statusCode != 200) print('POST 실패: ${res.statusCode}');
  }
}
