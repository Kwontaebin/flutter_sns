import 'package:flutter/material.dart';

void nullSnapBar(BuildContext context) {
  final snackBar = SnackBar(
    content: const Text('전부다 작성해주세요'),
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
    content: const Text('이메일 형식이 잘못되었습니다.'),
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
    content: const Text('비밀번호에 특수문자를 포함해주세요'),
    action: SnackBarAction(
      label: '확인',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void sameId(BuildContext context) {
  final snackBar = SnackBar(
    content: const Text('중복되는 아이디가 있습니다.'),
    action: SnackBarAction(
      label: '확인',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void sameName(BuildContext context) {
  final snackBar = SnackBar(
    content: const Text('중복되는 이름이 있습니다.'),
    action: SnackBarAction(
      label: '확인',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void signSuccess(BuildContext context) {
  final snackBar = SnackBar(
    content: const Text('회원가입 성공!'),
    action: SnackBarAction(
      label: '확인',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
