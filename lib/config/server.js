const express = require('express');
const app = express();
const db = require('./db.js');
const multiDb = require('./multi_db.js');
const crypto = require("crypto");
const bodyParser = require('body-parser');
const PORT = process.env.PORT || "4000";
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended:true}));
// 이 코드가 없으면 post를 할수가 없다!
app.use(express.json());

// 모든 유저 정보 가져오기
app.get('/userList', (req, res) => {
    db.query(`select * from user`, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 내 정보 가져오기
app.get('/myInformation/:id',(req, res) => {
    const { id } = req.params;

    db.query(`select * from user where id = "${id}"`, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 회원가입
app.post('/addUser', (req, res) => {
    const { userId, userPw, name } = req.body;

    db.query(`insert into user(userId, userPw, name, userIcon, postNum, follower, following) values("${userId}", "${userPw}", "${name}", "assets/images/user_icon.png", 0, 0, 0)`, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 게시글 모음
app.get('/postList', (req, res) => {
    let query1 = `select * from post;`;
    let query2 = `SELECT JSON_EXTRACT(img, '$[0]') AS value1,
                    JSON_EXTRACT(img, '$[1]') AS value2,
                   JSON_EXTRACT(img, '$[2]') AS value3
                   from post;`

    multiDb.query(query1 + query2, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 오직 게시글만
app.get('/getOnlyPostList', (req, res) => {
    db.query(`select * from post`, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 나의 게시글만 가져오기
app.get('/getMyPost/:id', (req, res) => {
    const { id } = req.params;

    let query1 = `select * from post where userId="${id}";`;
    let query2 = `SELECT JSON_EXTRACT(img, '$[0]') AS value1
                   from post where userId="${id}";`

    multiDb.query(query1 + query2, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 해당 게시글만 가져오기
app.get('/viewDetailPost/:id', (req, res) => {
    const { id } = req.params;

    db.query(`select * from post where id="${id}"`, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 댓글 작성하기
app.post('/postComment', (req, res) => {
    const { post_id, user_id, name, comment } = req.body;

    db.query(`insert into comment(post_id, user_id, name, comment) values("${post_id}", "${user_id}", "${name}", "${comment}")`, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 댓글 가져오기
app.get('/getComment/:id', (req, res) => {
    const { id } = req.params;

    db.query(`select * from comment where post_id=${id} limit 0, 3`, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 모든 댓글 가져오기
app.get('/getAllComment/:id', (req, res) => {
    const { id } = req.params;

    db.query(`select * from comment where post_id=${id}`, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 좋아요 추가
app.post('/postLike', (req, res) => {
    const {post_id, user_id, likeNum} = req.body;

    const query1  = `update post set likeNum=${likeNum + 1} where id="${post_id}";`;
    const query2 = `insert into post_like(post_id, user_id) values("${post_id}", "${user_id}");`;
    
    multiDb.query(query1 + query2, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 좋아요 삭제
app.delete('/removelike/:postId/:userId/:likeNum', (req, res) => {
    const {postId, userId, likeNum} = req.params;

    const query1 = `update post set likeNum=${likeNum - 1} where id="${postId}";`;
    const query2 = `delete from post_like where post_id="${postId}" and user_id="${userId}";`;

    multiDb.query(query1 + query2, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 모든 좋아요 목록 가져오기
app.get('/AllgetLike', (req, res) => {
    db.query(`select * from post_like`, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 좋아요 목록 가져오기
app.get('/getLike/:user_id', (req, res) => {
    const { user_id } = req.params;

    db.query(`select * from post_like where user_id="${user_id}"`, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 팔로우 목록 가져오기
app.get('/getFollowList', (req, res) => {    
    db.query(`select * from follow`, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 팔로우 하기
app.post('/addFollow', (req, res) => {
    const { user_id, my_id, follower, following } = req.body;
    const query1 = `insert into follow(user_id, my_id) values("${user_id}", "${my_id}");`
    const query2 = `update user set follower="${follower + 1}" where id="${user_id}";`;
    const query3 = `update user set following="${following + 1}" where id="${my_id}";`;

    multiDb.query(query1 + query2 + query3, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 팔로우 취소
app.put('/deleteFollow', (req, res) => {
    const { user_id, my_id, follower, following } = req.body;
    // DELETE FROM Reservation WHERE Name = '홍길동';
    const query1 = `delete from follow where user_id="${user_id}" and my_id="${my_id}";`
    const query2 = `update user set follower="${follower - 1}" where id="${user_id}";`;
    const query3 = `update user set following="${following - 1}" where id="${my_id}";`;

    multiDb.query(query1 + query2 + query3, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// follower 목록 가져오기
app.get('/getMyFollower/:id', (req, res) => {
    const { id } = req.params;

    db.query(`select * from follow where my_id="${id}"`, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 특정 게시물 찾기
app.get('/searchPost/:text', (req, res) => {
    const { text } = req.params;

    let query1 = `select * from post where text like "%${text}%";`;

    db.query(query1, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 게시글 작성하기
app.post('/addPost', (req, res) => {
    const { userId, name, img, text, postNum } = req.body;
    const query1 = `insert into post(userId, name, userIcon, img, text, date, likeImg, likeNum) values("${userId}", "${name}", "assets/images/user_icon.png", '[${img}]', "${text}", now(), "assets/images/black_heart.jpg", 0);`;
    const query2 = `update user set postNum="${postNum + 1}" where id="${userId}";`;

    multiDb.query(query1 + query2, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 게시글 삭제
app.put('/deletePost', (req, res) => {
    const { pageId, postNum, userId } = req.body;

    const query1 = `delete from post where id="${pageId}";`;
    const query2 = `update user set postNum="${postNum - 1}" where id="${userId}";`;
    
    multiDb.query(query1 + query2, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

// 게시글 수정
app.put('/PostUpdateText', (req, res) => {
    const { text, id } = req.body;

    db.query(`update post set text="${text}" where id="${id}"`, (err, data) => {
        if(!err) return res.json(data);
        return console.log(err);
    })
})

app.listen(PORT, () => {
    console.log(`Server On http://localhost:${PORT}`);
});