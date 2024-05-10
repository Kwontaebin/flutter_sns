// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sns/login/login_snapbar.dart';
import '../design.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.loginId,
    required this.loginPw,
  });

  final String loginId;
  final String loginPw;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String loginId = widget.loginId;
  late String loginPw = widget.loginPw;
  List<dynamic> data = [];

  List<bool> likeImgList = [];
  bool hasFunctionExecuted = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width90 = size.width * 0.9;
    final height10 = size.height * 0.1;

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 100),
                child: Text(
                  "Flutter",
                  style: BASIC_FONT,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: SizedBox(
                  width: width90,
                  height: height10,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "아이디를 입력해주세요",
                      hintText: '아이디 입력',
                      // 회원가입에서 사용
                      // helperText: "@를 사용해서 이메일 형식으로 작성해주세요",
                    ),
                    onChanged: (value) {
                      setState(() {
                        loginId = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                width: width90,
                height: height10,
                child: TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "비밀번호를 입력해주세요",
                    hintText: '비밀번호 입력',
                  ),
                  onChanged: (value) {
                    setState(() {
                      loginPw = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 100, left: 230),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.pushNamed(context, '/sign');
                    });
                  },
                  child: const Text(
                    "화원가입 하시겠습니까?",
                  ),
                ),
              ),
              ElevatedButton(
                // ! Statefulwidget을 하지 않으면 setState를 사용하지 못한다.
                // onPressed 누르면 데이터 전달하기
                style: basicButton,
                onPressed: () {
                  setState(() {
                    loginFn();
                  });
                },
                child: const Text(
                  "로그인",
                  style: LOGIN_FONT,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginFn() async {
    var response = await http.get(Uri.parse("http://localhost:4000/userList"));

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    }

    var bytes = utf8.encode(loginPw);
    var hashPw = sha256.convert(bytes).toString();
    String status = "";
    late int id;
    late String name;

    if (loginId == "" || loginPw == "") {
      nullSnapBar(context);
    }

    if (data.length != 0) {
      for (int i = 0; i < data.length; i++) {
        RegExp idValue = RegExp(data[i]["userId"]);
        RegExp pwValue = RegExp(data[i]["userPw"]);

        bool idMatch = idValue.hasMatch(loginId);
        bool pwMatch = pwValue.hasMatch(hashPw);

        if (idMatch == true) {
          if (pwMatch == true) {
            status = "success";
            id = data[i]["id"];
            name = data[i]["name"];
            break;
          } else {
            status = "pwErr";
            break;
          }
        } else {
          status = "idErr";
        }
      }
    }

    if (status == "idErr") idErrSnapBar(context);
    if (status == "pwErr") pwErrSnapBar(context);
    if (status == "success") {
      print("로그인 성공");
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setInt('id', id);
      pref.setString('name', name);
      // likeImg();

      Navigator.pushNamed(context, "/home");
    }
  }
}
