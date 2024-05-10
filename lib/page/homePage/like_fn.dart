import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> like({required int postId, int? likeNum}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<dynamic> likeData = [];
  int? userId = prefs.getInt("id");
  bool overlap = false;

  var likeList = await http.get(Uri.parse("http://localhost:4000/AllgetLike"));

  likeData = json.decode(likeList.body);

  for (int i = 0; i < likeData.length; i++) {
    if (postId == likeData[i]["post_id"] && userId == likeData[i]["user_id"]) {
      var url = Uri.parse("http://localhost:4000/removelike/$postId/$userId/$likeNum");

      var response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) print('DELETE 성공: ${response.body}');
      if (response.statusCode != 200) print('DELETE 실패: ${response.statusCode}');
      overlap = false;
      break;
    } else {
      overlap = true;
    }
  }

  if (overlap == true) {
    var url = Uri.parse("http://localhost:4000/postLike");
    var data = {
      "post_id": postId,
      "user_id": userId,
      "likeNum": likeNum,
    };

    var response = await http.post(
      url,
      body: json.encode(data),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      print('POST 성공: ${response.body}');
    }
    if (response.statusCode != 200) {
      print('POST 실패: ${response.statusCode}');
    }
  }
}