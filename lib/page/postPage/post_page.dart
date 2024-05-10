import 'dart:convert';
import 'dart:io';
import 'package:flutter_sns/page/postPage/post_page_snackBar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_sns/design.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostPage extends StatefulWidget {
  const PostPage({
    super.key,
  });

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final List<File> _images = [];
  List<dynamic> img = [];
  List<String> imgList = [];
  final int pageCount = 3;
  String text = "";

  @override
  final PageController pageController = PageController(
    // 먼저 보여줄 페이지
    // initialPage: 10, = 10페이지를 먼저 보여줌
    initialPage: 0,
    // 보여지는 화면의 width크기를 뜻한다.
    viewportFraction: 1.0,
  );

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages != null) {
      setState(() {
        _images.clear();
        _images
            .addAll(pickedImages.map((pickedImage) => File(pickedImage.path)));
      });

      // Save images to 'upload' folder
      await _saveImagesToUploadFolder();
    }
  }

  Future<void> _saveImagesToUploadFolder() async {
    const appDir = "/Users/kwonteabin/StudioProjects/flutter_sns/assets";
    final uploadDir = Directory('$appDir/uploads');
    if (!uploadDir.existsSync()) {
      uploadDir.createSync(recursive: true);
    }

    for (int i = 0; i < _images.length; i++) {
      final image = _images[i];
      final fileName =
          'image_${DateTime.now().millisecondsSinceEpoch}.png'; // You can change the naming convention here
      final imagePath = '${uploadDir.path}/$fileName';
      // final imagePath = '/assets/uploads/$fileName';
      await image.copy(imagePath);
      img.add("assets/uploads/$fileName");
      imgList = img.map((value) => '"$value"').toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            print(img);
          },
          child: const Text(
            "Flutter",
            style: BASIC_FONT,
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: 800,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 350,
              child: _images.isEmpty
                  ? const Center(child: Text('이미지를 선택하지 않았습니다.'))
                  : PageView.builder(
                      itemCount: pageCount,
                      scrollDirection: Axis.horizontal,
                      controller: pageController,
                      physics: const BouncingScrollPhysics(),

                      // 필수 - 목록의 갯수
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: double.infinity,
                          height: 350,
                          child: Image.file(
                            _images[index],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: '문구 입력...',
                    suffixIcon: GestureDetector(
                      child: const Icon(
                        Icons.send,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      text = value;
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
                style: postButton,
                onPressed: () {
                  setState(() {
                    addPost();
                  });
                },
                child: const Text(
                  "게시글 작성",
                  style: LOGIN_FONT,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImages,
        tooltip: 'Pick Images',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Future<void> addPostFn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("id");
    String? name = prefs.getString("name");
    List<dynamic> userDataList = [];

    var url = Uri.parse("http://localhost:4000/addPost");
    var userData = await http.get(Uri.parse("http://localhost:4000/myInformation/$userId"));
    userDataList = json.decode(userData.body);

    var data = {"userId": userId, "name": name, "img": imgList, "text": text, "postNum": userDataList[0]["postNum"]};

    var response = await http.post(
      // post하는 url주소
      url,
      body: json.encode(data),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) print('POST 성공: ${response.body}');
    Navigator.pushNamed(context, '/home');
    if (response.statusCode != 200) print('POST 실패: ${response.statusCode}');
  }

  Future<void> addPost() async {
    if (imgList.length == 0) return nullImgList(context);
    else if (text == "") return nullText(context);
    return addPostFn();
  }
}
