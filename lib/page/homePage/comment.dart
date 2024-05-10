import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../design.dart';
import '../../user_data.dart';

class PostCommentPage extends StatefulWidget {
  const PostCommentPage({
    super.key,
    required this.id,
    required this.comment,
  });

  final int id;
  final String comment;

  @override
  State<PostCommentPage> createState() => _PostCommentPageState();
}

class _PostCommentPageState extends State<PostCommentPage> {
  late int id = widget.id;
  late String comment = widget.comment;

  Future fetch() async {
    var res = await http.get(Uri.parse("http://localhost:4000/getComment/$id"));
    return json.decode(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: 100,
            child: SizedBox(
              width: double.infinity,
              height: 100 / 3,
              child: commentList(),
            ),
          ),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: '댓글 입력...',
                suffixIcon: GestureDetector(
                  child: const Icon(
                    Icons.send,
                    color: Colors.blue,
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

    );
  }

  Future<void> postComment() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("id");
    String? name = prefs.getString("name");

    print(id);
    print(userId);
    print(comment);
    print(name);

    var url = Uri.parse("http://localhost:4000/postComment");
    var data = {
      "post_id": id,
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
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    snap.data[index]["name"],
                    style: POST_NAME,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    snap.data[index]["comment"],
                  ),
                ),
              ],
            );
          }
        );
      },
    );
  }
}
