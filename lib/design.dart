// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

const BASIC_FONT = TextStyle(
  fontFamily: "BasicFont",
  fontSize: 40,
  decoration: TextDecoration.none,
  fontWeight: FontWeight.bold,
  height: 10 / 10,
  color: Colors.black,
);

final postButton = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromARGB(255, 96, 154, 239),
  minimumSize: const Size(370, 65),

  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  elevation: 0.0,
);

final basicButton = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromARGB(255, 96, 154, 239),
  minimumSize: const Size(370, 65),

  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(0),
  ),
  elevation: 0.0,
);

const LOGIN_FONT = TextStyle(
  fontSize: 20,
  decoration: TextDecoration.none,
  fontWeight: FontWeight.bold,
  height: 10 / 10,
  color: Colors.white,
);

final followButton = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromARGB(255, 66, 136, 241),
);

final unFollowBtn = ElevatedButton.styleFrom(
  backgroundColor: Colors.red,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  )
);

final followBtn = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 66, 136, 241),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    )
);

const POST_NAME = TextStyle(
  fontSize: 16,
  decoration: TextDecoration.none,
  fontWeight: FontWeight.bold,
  height: 10 / 10,
  color: Colors.black,
);

const SEARCH_FONT = TextStyle(
  fontSize: 20,
  decoration: TextDecoration.none,
  fontWeight: FontWeight.bold,
  height: 10 / 10,
  color: Colors.black,
);

final deleteBtn = ElevatedButton.styleFrom(
    minimumSize: const Size(200, 65),
    backgroundColor: const Color.fromARGB(255, 241, 8, 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    )
);

final updateBtn = ElevatedButton.styleFrom(
    minimumSize: const Size(200, 65),
    backgroundColor: const Color.fromARGB(255, 29, 234, 11),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    )
);

const UPDATE_DELETE_FONT = TextStyle(
  fontSize: 17,
  decoration: TextDecoration.none,
  fontWeight: FontWeight.bold,
  height: 10 / 10,
  color: Colors.white,
);