import 'package:flutter/material.dart';
import 'package:flutter_sns/page/searchPage/post_search_page_widget.dart';

class PostSearchPage extends StatefulWidget {
  const PostSearchPage({
    super.key,
    required this.name,
  });

  final String? name;

  @override
  State<PostSearchPage> createState() => _PostSearchPageState();
}

class _PostSearchPageState extends State<PostSearchPage> {
  late String? name = widget.name;
  String text = "";
  List<dynamic> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$name"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () async {
            Navigator.pushNamed(context, '/home');
          },
        ),
      ),
      body: SearchPostPageWidget(name: name),
    );
  }
}