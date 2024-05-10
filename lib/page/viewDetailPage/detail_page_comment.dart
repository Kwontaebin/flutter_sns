import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../design.dart';
import '../../user_data.dart';

class DetailPageCommentPage extends StatefulWidget {
  const DetailPageCommentPage({
    super.key,
    required this.pageId,
  });

  final int pageId;

  @override
  State<DetailPageCommentPage> createState() => _DetailPageCommentPageState();
}

class _DetailPageCommentPageState extends State<DetailPageCommentPage> {
  late int pageId = widget.pageId;
  String comment = "";

  Future fetch() async {
    var res = await http
        .get(Uri.parse("http://localhost:4000/getAllComment/$pageId"));
    return json.decode(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              height: 180,
              child: commentList(),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 70,
            child: TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: '댓글 입력...',
                suffixIcon: GestureDetector(
                  child: const Icon(
                    Icons.send,
                    size: 20,
                  ),
                  onTap: () {
                    setState(() {
                      if (comment == "") return nullComment(context);
                      if (comment != "") postComment();
                    });
                  },
                ),
              ),
              onChanged: (text) {
                setState(() {
                  comment = text;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> postComment() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("id");
    String? name = prefs.getString("name");

    print(pageId);
    print(userId);
    print(comment);
    print(name);

    var url = Uri.parse("http://localhost:4000/postComment");
    var data = {
      "post_id": pageId,
      "user_id": userId,
      "name": name,
      "comment": comment
    };

    var response = await http.post(
      // post하는 url주소
      url,

      // req.body 에 json 형태로 담기위해 사용하는 코드
      // 전달받은 값을 JSON 형식의 문자열로 변환하여 반환
      body: json.encode(data),

      // post를 하는데 가장 중요하다!
      // 요즈음의 대부분의 request에 대한 Content-Type은 application/json 타입인 것이 많습니다.
      // application/json은 RestFul API를 사용하게 되며 request를 날릴 때 대부분 json을 많이 사용하게 됨에 따라 자연스럽게 사용이 많이 늘게 되었습니다.
      // https://jw910911.tistory.com/117
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) print('POST 성공: ${response.body}');
    if (response.statusCode != 200) print('POST 실패: ${response.statusCode}');
  }

  Widget commentList() {
    return FutureBuilder(
      future: fetch(), // 비동기 함수(JSON 수신 등)
      builder: (context, snap) {
        // CircularProgressIndicator: 데이터가 들어오지 않으면 원이 빙글빙글 돌면서 값이 들어오기를 기다린다.
        if (!snap.hasData) return const CircularProgressIndicator();
        return ListView.builder(
          itemCount: snap.data.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    snap.data[index]["name"],
                    style: POST_NAME,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    snap.data[index]["comment"],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}