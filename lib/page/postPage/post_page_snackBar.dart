import 'package:flutter/material.dart';

void nullImgList(BuildContext context) {
  final snackBar = SnackBar(
    content: const Text('이미지를 추가해주세요'),
    action: SnackBarAction(
      label: '확인',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void nullText(BuildContext context) {
  final snackBar = SnackBar(
    content: const Text('내용을 입력해주세요'),
    action: SnackBarAction(
      label: '확인',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
