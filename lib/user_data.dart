import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void logout() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.remove('id');
  await prefs.remove('name');
}

void getData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  print(prefs.getInt("id"));
}

void nullComment(BuildContext context) {
  final snackBar = SnackBar(
    content: const Text('댓글을 작성하세요'),
    action: SnackBarAction(
      label: '확인',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}