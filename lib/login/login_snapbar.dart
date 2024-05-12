import 'package:flutter/material.dart';

void nullSnapBar(BuildContext context) {
  final snackBar = SnackBar(
    content: const Text('전부다 작성해주세요.'),
    action: SnackBarAction(
      label: '확인',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void idErrSnapBar(BuildContext context) {
  final snackBar = SnackBar(
    content: const Text('이메일이 일치하지 않습니다.'),
    action: SnackBarAction(
      label: '확인',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void pwErrSnapBar(BuildContext context) {
  final snackBar = SnackBar(
    content: const Text('비밀번호가 일치하지 않습니다.'),
    action: SnackBarAction(
      label: '확인',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void loginSuccess(BuildContext context) {
  final snackBar = SnackBar(
    content: const Text('로그인 성공!'),
    action: SnackBarAction(
      label: '확인',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}