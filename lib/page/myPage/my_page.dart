import 'package:flutter/material.dart';
import '../../user_data.dart';
import 'my_page_header.dart';
import 'my_page_main.dart';

class MyPage extends StatefulWidget {
  const MyPage({
    super.key,
    required this.name,
    required this.id,
  });

  final String? name;
  final int? id;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late String? name = widget.name;
  late int? id = widget.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$name",
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),

          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout();
              logoutSuccess(context);
              Navigator.pushNamed(context, '/');
              print('로그아웃');
            },
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: 850,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 200,
                child: MyPageHeader(id: id, name: name),
              ),
              SizedBox(
                width: double.infinity,
                height: 650,
                child: MyPageMain(id: id),
              )
            ],
          ),
        ),
      ),
    );
  }

  void logoutSuccess(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('로그아웃'),
      action: SnackBarAction(
        label: '확인',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
