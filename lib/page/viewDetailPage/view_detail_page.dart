import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sns/page/viewDetailPage/view_detail_page_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../design.dart';
import '../updatePage/post_update.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.pageId,
    required this.id,
  });

  final int pageId;
  final int? id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late int pageId = widget.pageId;
  late int? id = widget.id;
  List<dynamic> userData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flutter",
          style: BASIC_FONT,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              int? userId = prefs.getInt("id");

              if (userId != id)
                return agreementUser(context);
              else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostUpdatePage(pageId: pageId),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              int? userId = prefs.getInt("id");

              if (userId != id)
                return agreementUser(context);
              else {
                deleteData();
              }
            },
          )
        ],
      ),
      body: ViewDetailPageWidget(pageId: pageId),
    );
  }

  void agreementUser(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('이 글을 올린 사용자만 접근할수있습니다.'),
      action: SnackBarAction(
        label: '확인',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> deleteData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("id");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('게시물을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () async {
                print('확인 버튼을 눌렀습니다.');
                var userDataUrl = await http.get(Uri.parse("http://localhost:4000/myInformation/$userId"));
                userData = json.decode(userDataUrl.body);
                var url = Uri.parse("http://localhost:4000/deletePost");

                var data = {"pageId":pageId, "postNum": userData[0]["postNum"], "userId": userId};

                var response = await http.put(
                  url,
                  body: json.encode(data),
                  headers: {"Content-Type": "application/json"},
                );

                if (response.statusCode == 200) print('DELETE 성공: ${response.body}'); Navigator.pushNamed(context, '/home');
                if (response.statusCode != 200) print('DELETE 실패: ${response.statusCode}'); // 경고창 닫기
              },
              child: const Text('삭제'),
            ),
            TextButton(
              onPressed: () {
                print('취소 버튼을 눌렀습니다.');
                Navigator.of(context).pop(); // 경고창 닫기
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }
}
