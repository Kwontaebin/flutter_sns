// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sns/sign/sign_snackbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../design.dart';
import 'package:crypto/crypto.dart';

class SignPage extends StatefulWidget {
  const SignPage({
    super.key,
    required this.signId,
    required this.signPw,
    required this.signName,
  });

  final String signId;
  final String signPw;
  final String signName;

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  late String signId = widget.signId;
  late String signPw = widget.signPw;
  late String signName = widget.signName;
  List<dynamic> data = [];

  bool _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width90 = size.width * 0.9;
    final height10 = size.height * 0.1;

    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  "Flutter",
                  style: BASIC_FONT,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SizedBox(
                  width: width90,
                  height: height10,
                  child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "아이디를 입력해주세요",
                        hintText: '아이디 입력',
                        // 회원가입에서 사용
                        helperText: "@를 사용해서 이메일 형식으로 작성해주세요.",
                      ),
                      onChanged: (value) {
                        setState(() {
                          signId = value;
                        });
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: width90,
                  height: height10,
                  child: TextField(
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "비밀번호를 입력해주세요",
                      hintText: '비밀번호 입력',
                      helperText: "특수문자 포함하세요",
                      // 비밀번호 암호 true, false 다시 해보기!
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: _toggleObscureText,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        signPw = value;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: width90,
                  height: height10,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "이름을 입력해주세요",
                      hintText: '이름 입력',
                    ),
                    onChanged: (value) {
                      setState(() {
                        signName = value;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: ElevatedButton(
                  // ! Statefulwidget을 하지 않으면 setState를 사용하지 못한다.
                  // onPressed 누르면 데이터 전달하기
                  style: basicButton,
                  onPressed: () {
                    setState(() {
                      signFn();
                    });
                  },
                  child: const Text(
                    "회원가입",
                    style: LOGIN_FONT,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> postData() async {
    var bytes = utf8.encode(signPw);
    var hashPw = sha256.convert(bytes).toString();

    var url = Uri.parse("http://localhost:4000/addUser");
    var data = {
      "userId": signId,
      "userPw": hashPw,
      "name": signName
    }; // 이 데이터를 원하는 형식으로 구성하세요.

    var response = await http.post(
      // post하는 url주소
      url,
      body: json.encode(data),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) print('POST 성공: ${response.body}');
    Navigator.pop(context);
    if (response.statusCode != 200) print('POST 실패: ${response.statusCode}');
  }

  void signFn() async {
    var response = await http.get(Uri.parse("http://localhost:4000/userList"));

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    }

    if (signId == "" || signPw == "" || signName == "") {
      nullSnapBar(context);
      return;
    } else if (signId.contains("@") == false ||
        signId[signId.length - 1] != "m") {
      idErrSnapBar(context);
      return;
    } else if (signPw.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) == false) {
      pwErrSnapBar(context);
      return;
    }

    if(data.length != 0) {
      for (int i = 0; i < data.length; i++) {
        if (data[i]["userId"].toString() == signId) {
          sameId(context);
          break;
        } else if (data[i]["name"].toString() == signName) {
          sameName(context);
          break;
        } else {
          print("성공");
          signSuccess(context);
          await postData();
          break;
        }
      }
    }
  }
}