import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../viewDetailPage/view_detail_page.dart';

class MyPageMain extends StatefulWidget {
  const MyPageMain({
    super.key,
    required this.id,
  });

  final int? id;

  @override
  State<MyPageMain> createState() => _MyPageMainState();
}

class _MyPageMainState extends State<MyPageMain> {
  List<dynamic> data = [];
  late int? id = widget.id;

  @override
  void initState() {
    super.initState();

    fetch();
  }

  void fetch() async {

    var res = await http.get(Uri.parse("http://localhost:4000/getMyPost/$id"));

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
      height: double.infinity,
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 1.0, // 가로 간격
          mainAxisSpacing: 1.0,
          childAspectRatio: 0.8,
        ),
        children: [
          for (int i = 0; i < data[0].length; i++)
            if (data[0].length != 0)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailPage(pageId: data[0][i]["id"], id: id),
                    ),
                  );
                },
                child: Image.asset(
                  data[1][i]["value1"],
                  width: 35,
                  height: 35,
                  fit: BoxFit.cover,
                ),
              ),
          if (data[0].length == 0)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "게시글이 없습니다",
              ),
            ),
        ],
      ),
    );
  }
}
