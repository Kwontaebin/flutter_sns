import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../design.dart';
import '../searchPage/follow_fn.dart';

class MyPageHeader extends StatefulWidget {
  const MyPageHeader({
    super.key,
    required this.id,
    required this.name,
  });

  final int? id;
  final String? name;

  @override
  State<MyPageHeader> createState() => _MyPageHeaderState();
}

class _MyPageHeaderState extends State<MyPageHeader> {
  List<dynamic> data = [];
  late int? id = widget.id;
  late String? name = widget.name;

  Future fetch() async {

    var res =
        await http.get(Uri.parse("http://localhost:4000/myInformation/$id"));

    if (res.statusCode == 200) {
      setState(() {
        data = json.decode(res.body);
      });
    }

    return json.decode(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetch(),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: Text("loading!!"));

        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 20),
                    child: Image.asset(
                      snap.data[0]["userIcon"],

                      width: 100, // image 16:9 = 0.57...
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Posts \n \n   ${snap.data[0]["postNum"]}",
                      style: POST_NAME,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "follower \n \n     ${snap.data[0]["follower"]}",
                      style: POST_NAME,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "following \n \n      ${snap.data[0]["following"]}",
                      style: POST_NAME,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 100),
                child: SizedBox(
                  width: 280,
                  height: 50,
                  child: ElevatedButton(
                    style: followButton,
                    onPressed: () {
                      follow(userId: id, context: context);
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
        );
      },
    );
  }
}
