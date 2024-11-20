import 'package:flutter/material.dart';
import 'package:uas_twitter_mediasosial/pages/profile_page.dart';

import '../models/post.dart';
import '../pages/post_page.dart';

void goUserpage(BuildContext context, String uid) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfilePage(uid: uid),
    ),
  );
}

void goPostPage(BuildContext context, Post post) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PostPage(post: post,)
    ),
  );
}

void goHomePage(BuildContext context) {
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(),
  ),
  (route) => route.isFirst,
  );
}