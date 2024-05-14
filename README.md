# **Flutter SNS 프로젝트**

프로젝트 소개
- 소셜 미디어 프로젝트로 자신의 일상을 공유하고 온라인 상의 친구를 만들수 있는 SNS입니다.
- 유저들을 팔로우하며 마음에 드는 게시글에 좋아요를 누르거나 댓글을 작성할 수 있습니다.
- 검색을 통해 자신이 찾고 있는 게시글을 찾을수 있습니다.

## 1. 개발 환경
- #### App Front-end : Dart, FLutter
- #### back-end : Mysql, Node-js
- #### 디자인 참고 : 인스타그램

## 2. 프로젝트 구조
📦lib <br/> 
 ┣ 📂config <br/> 
 ┃ ┣ 📜db.js <br/>
 ┃ ┣ 📜multi_db.js <br/>
 ┃ ┣ 📜package-lock.json <br/>
 ┃ ┣ 📜package.json <br/>
 ┃ ┗ 📜server.js <br/>
 ┣ 📂login <br/>
 ┃ ┣ 📜login.dart <br/>
 ┃ ┗ 📜login_snapbar.dart <br/>
 ┣ 📂page <br/>
 ┃ ┣ 📂homePage <br/>
 ┃ ┃ ┣ 📜comment.dart <br/>
 ┃ ┃ ┣ 📜comment_page.dart <br/>
 ┃ ┃ ┣ 📜homePage.dart <br/>
 ┃ ┃ ┣ 📜homePageDesign.dart <br/>
 ┃ ┃ ┗ 📜like_fn.dart <br/>
 ┃ ┣ 📂myPage <br/>
 ┃ ┃ ┣ 📜my_page.dart <br/>
 ┃ ┃ ┣ 📜my_page_header.dart <br/>
 ┃ ┃ ┗ 📜my_page_main.dart <br/>
 ┃ ┣ 📂postPage <br/>
 ┃ ┃ ┣ 📜post_page.dart <br/>
 ┃ ┃ ┗ 📜post_page_snackBar.dart <br/>
 ┃ ┣ 📂searchPage <br/>
 ┃ ┃ ┣ 📜follow_fn.dart <br/>
 ┃ ┃ ┣ 📜friend_search_page.dart <br/>
 ┃ ┃ ┣ 📜post_search_page.dart <br/>
 ┃ ┃ ┣ 📜post_search_page_widget.dart <br/>
 ┃ ┃ ┗ 📜searchPageHeader.dart <br/>
 ┃ ┣ 📂updatePage <br/>
 ┃ ┃ ┗ 📜post_update.dart <br/>
 ┃ ┗ 📂viewDetailPage <br/>
 ┃ ┃ ┣ 📜detail_page_comment.dart <br/>
 ┃ ┃ ┣ 📜view_detail_page.dart <br/>
 ┃ ┃ ┗ 📜view_detail_page_widget.dart <br/>
 ┣ 📂sign <br/>
 ┃ ┣ 📜sign.dart <br/>
 ┃ ┗ 📜sign_snackbar.dart <br/>
 ┣ 📜.DS_Store <br/>
 ┣ 📜design.dart <br/>
 ┣ 📜main.dart <br/>
 ┗ 📜user_data.dart <br/>

 ## 3. 개발 기간
 - 2024.04.15 ~ 2024.05.10

 ## 3. 페이지별 기능
 ### 회원가입
 - 유효성 검사를 실시해서 중복되는 이메일이나 이름이 있을경우 하단에 경고창(스넥 바)를 띄웁니다.
<div style="height: 200px; width: 500px;">
    <img style="height: 600px; width: 250px; float:left;" src="/images/sign_img1.png">
    <img style="height: 600px; width: 250px; float:left;" src="/images/sign_img2.png">
</div>
<br/>

- 아이디가 이메일형식이 아닐경우 하단에 경고창(스넥 바)를 띄웁니다.
- 비밀번호에 특수문자가 포함되어있지 않다면 하단에 경고창(스넥 바)를 띄웁니다.
- 전부다 작성하지 않으면 하단에 경고창(스넥 바)를 띄웁니다.
<div style="height: 200px; width: 500px;">
    <img style="height: 600px; width: 250px; float:left;" src="/images/sign_img3.png">
    <img style="height: 600px; width: 250px; float:left;" src="/images/sign_img4.png">
    <img style="height: 600px; width: 250px; float:left;" src="/images/sign_img5.png">
</div>
<br/>

- 비밀번호 옆에 아이콘을 클릭하면 비밀번호를 점(･)으로 보거나 입력한대로 보거나 왔다갔다 할수있습니다.
<div style="height: 200px; width: 500px;">
    <img style="height: 600px; width: 250px; float:left;" src="/images/sign_img7.png">
    <img style="height: 600px; width: 250px; float:left;" src="/images/sign_img8.png">
</div>
<br/>

- 회원가입에 성공하면 로그인 페이지로 이동합니다.
- 회원가입된 정보는 DB에 저장됩니다.
<img style="height: 600px; width: 250px; float:left;" src="/images/sign_img6.png">
<br/>

### 로그인
- DB를 검사해서 아이디와 비밀번호 모두 일치하는 정보가 있는지 확인합니다.
- 일치하는 정보가 없다면 하단에 경고창(스넥 바)를 띄웁니다.
<div style="height: 200px; width: 500px;">
    <img style="height: 600px; width: 250px; float:left;" src="/images/login_img1.png">
    <img style="height: 600px; width: 250px; float:left;" src="/images/login_img2.png">
</div>
<br/>

- 일치하는 회원의 정보가 있다면 로그인에 성공하고 메인 페이지로 이동합니다.
- 로그인 성공시 shared_preferences 라이브러리를 사용해서 DB의 컬럼(Id, Name)을 저장합니다.
<img style="height: 600px; width: 250px; float:left;" src="/images/login_img3.png">
<br/>

## 메인 페이지
- 전체 사용자가 올린 게시글을 확인할수있습니다.
- 이미지를 스와이프 하여 여러개의 이미지를 볼수있습니다.
<img style="height: 600px; width: 250px; float:left;" src="/images/main_img1.png">
<br/>

- 댓글을 작성할수 있습니다.
<div style="height: 200px; width: 500px;">
    <img style="height: 600px; width: 250px; float:left;" src="/images/main_img2.png">
    <img style="height: 600px; width: 250px; float:left;" src="/images/main_img3.png">
</div>
<br/>

- 아무것도 입력하지 않고 댓글을 작성할경우 "댓글을 작성하세요" 경고창이 나옵니다.
<img style="height: 600px; width: 250px; float:left;" src="/images/main_img4.png">
<br/>

- 댓글 아이콘을 클릭하면 전체 댓글을 볼수있습니다.
- 기존에 댓글은 3개만 볼수있습니다.
<div style="height: 200px; width: 500px;">
    <img style="height: 600px; width: 250px; float:left;" src="/images/main_img7.png">
    <img style="height: 600px; width: 250px; float:left;" src="/images/main_img8.png">
</div>
<br/>

- 하트 아이콘을 클릭하면 게시글에 좋아요를 누를수 있습니다.
- 좋아요를 누른 게시글
<img style="height: 600px; width: 250px; float:left;" src="/images/main_img4.png">
<br/>

- 좋아요를 누르지 않은 게시글
<img style="height: 600px; width: 250px; float:left;" src="/images/main_img6.png">
<br/>

- 게시글의 이미지를 클릭하면 해당 게시글을 상세하게 보는 페이지로 이동합니다.
<div style="height: 200px; width: 500px;">
    <img style="height: 600px; width: 250px; float:left;" src="/images/main_img9.png">
    <img style="height: 600px; width: 250px; float:left;" src="/images/main_img10.png">
</div>
<br/>

- 게시글의 유저 아이콘을 클릭하면 유저 페이지로 이동할수있습니다.
<div style="height: 200px; width: 500px;">
    <img style="height: 600px; width: 250px; float:left;" src="/images/main_img13.png">
    <img style="height: 600px; width: 250px; float:left;" src="/images/main_img12.png">
</div>
<br/>

## 유저 페이지
- 해당 아이콘, 버튼을 클릭하면 페이지에 들어갈수있습니다.
<div style="height: 200px; width: 500px;">
    <img style="height: 600px; width: 250px; float:left;" src="/images/main_img13.png">
    <img style="height: 600px; width: 250px; float:left;" src="/images/my_page_img1.png">
</div>
<br/>

- 유저의 전체 게시글을 확인할수있습니다.
- 유저의 게시글수, 팔로우수, 팔로워수 를 확인할수 있습니다.
<img style="height: 600px; width: 250px; float:left;" src="/images/my_page_img4.png">
<br/>

- 게시글의 이미지를 클릭해서 상세보기 페이지로 들어갈수있습니다.
<div style="height: 200px; width: 500px;">
    <img style="height: 600px; width: 250px; float:left;" src="/images/my_page_img2.png">
    <img style="height: 600px; width: 250px; float:left;" src="/images/main_img10.png">
</div>
<br/>

- 해당 아이콘을 클릭해서 로그아웃을 할수있습니다.
- 로그아웃시 shared_preferences로 저장한 로그인 유저의 정보를 삭제하고 로그인 페이지로 이동합니다.
<div style="height: 200px; width: 500px;">
    <img style="height: 600px; width: 250px; float:left;" src="/images/my_page_img3.png">
    <img style="height: 600px; width: 250px; float:left;" src="/images/my_page_img5.png">
</div>
<br/>

- 팔로우 하지 않은 유저를 팔로우 할수있습니다.
<img style="height: 600px; width: 250px; float:left;" src="/images/my_page_img8.png">

- "팔로우 취소하시겠습니까" 확인을 누르면 팔로우 취소를 할수있습니다.
- "팔로우 취소하시겠습니까" 취소를 누르면 아무일도 일어나지 않습니다.
<div style="height: 200px; width: 500px;">
    <img style="height: 600px; width: 250px; float:left;" src="/images/my_page_img6.png">
    <img style="height: 600px; width: 250px; float:left;" src="/images/my_page_img7.png">
</div>
<br/>

- 자기 자신을 팔로우 할수 없습니다.
<img style="height: 600px; width: 250px; float:left;" src="/images/my_page_img9.png">
<br/>

### 상세보기 페이지
- 게시글을 상세하게 볼수있습니다.
- 기존에 3개로 제한되던 댓글을 모두 볼수있습니다.
- 좋아요를 누르거나 댓글을 작성할수있습니다
- 이미지를 스와이프 하여 여러개의 이미지를 볼수있습니다.
<img style="height: 600px; width: 250px; float:left;" src="/images/main_img10.png">
<br/>

- 해당 아이콘을 클릭하면 수정하기 페이지로 이동후 게시글을 수정할수있습니다. 
<div style="height: 200px; width: 500px;">
    <img style="height: 600px; width: 250px; float:left;" src="/images/detail_page_img1.png">
    <img style="height: 600px; width: 250px; float:left;" src="/images/update_img1.png">
    <img style="height: 600px; width: 250px; float:left;" src="/images/update_img2.png">
</div>
<br/>

- 해당 아이콘을 클릭하면 게시글을 삭제 할수 있습니다.
<div style="height: 200px; width: 500px;">
    <img style="height: 600px; width: 250px; float:left;" src="/images/detail_page_img2.png">
    <img style="height: 600px; width: 250px; float:left;" src="/images/delete_img1.png">
</div>
<br/>

- 게시글을 삭제하거나 수정하는것은 게시글을 올린 사용자가 아니면 할수없습니다.
<img style="height: 600px; width: 250px; float:left;" src="/images/delete_img2.png">
<br/>

### 게시글 작성 페이지
- 해당 아이콘을 클릭하면 게시글 작성 페이지로 이동합니다
<img style="height: 600px; width: 250px; float:left;" src="/images/post_page_img1.png">
<br/>

- 이미지와 내용중 하나라도 입력하지 않으면 게시글을 작성할수없습니다.
- 전부다 작성하지 않더라도 게시글을 작성할수없습니다.
<div style="height: 200px; width: 500px;">
    <img style="height: 600px; width: 250px; float:left;" src="/images/post_page_img3.png">
    <img style="height: 600px; width: 250px; float:left;" src="/images/post_page_img4.png">
</div>
<br/>

- 게시글 작성이 완료되었을떄 화면입니다.
<img style="height: 600px; width: 250px; float:left;" src="/images/post_page_img5.png">
