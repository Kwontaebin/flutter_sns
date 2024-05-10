import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<void> follow({
  required int? userId,
  required BuildContext context,
}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int? myId = prefs.getInt("id");
  List<dynamic> followData = [];
  List<dynamic> userData = [];
  List<dynamic> myData = [];
  bool followStatus = false;

  var getFollowData = await http.get(Uri.parse("http://localhost:4000/getFollowList"));
  var getUserData = await http.get(Uri.parse("http://localhost:4000/myInformation/$userId"));
  var getMyData = await http.get(Uri.parse("http://localhost:4000/myInformation/$myId"));

  followData = json.decode(getFollowData.body);
  userData = json.decode(getUserData.body);
  myData = json.decode(getMyData.body);

  if (userId == myId) {
    followErr(context);
    return;
  }

  for (int i = 0; i < followData.length; i++) {
    if(followData[i]["user_id"] == userId && followData[i]["my_id"] == myId) {
      print("이미 팔로우 하고있습니다");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('팔로우취소 하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () async {
                  print('확인 버튼을 눌렀습니다.');
                  var url = Uri.parse("http://localhost:4000/deleteFollow");
                  var addFollowData = {
                    "user_id": userId,
                    "my_id": myId,
                    "follower": userData[0]["follower"],
                    "following": myData[0]["following"],
                  };

                  var deleteResponse = await http.put(
                    url,
                    body: json.encode(addFollowData),
                    headers: {"Content-Type": "application/json"},
                  );

                  if (deleteResponse.statusCode == 200) print('POST 성공: ${deleteResponse.body}');
                  if (deleteResponse.statusCode != 200) print('POST 실패: ${deleteResponse.statusCode}');

                  Navigator.of(context).pop(); // 경고창 닫기
                },
                child: const Text('확인'),
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
      followStatus = false;
      return;
    } else {
      followStatus = true;
    }
  }

  if(followData.length == 0 || followStatus == true) {
    var url = Uri.parse("http://localhost:4000/addFollow");
    var addFollowData = {
      "user_id": userId,
      "my_id": myId,
      "follower": userData[0]["follower"],
      "following": myData[0]["following"],
    };

    var addResponse = await http.post(
      url,
      body: json.encode(addFollowData),
      headers: {"Content-Type": "application/json"},
    );

    if (addResponse.statusCode == 200) print('POST 성공: ${addResponse.body}');
    if (addResponse.statusCode != 200) print('POST 실패: ${addResponse.statusCode}');
  }
}

// 자기 자신을 팔로우했을떄 에러를 표시하는 snackBar
void followErr(BuildContext context) {
  final snackBar = SnackBar(
    content: const Text('자신을 팔로우할수없습니다.'),
    action: SnackBarAction(
      label: '확인',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
