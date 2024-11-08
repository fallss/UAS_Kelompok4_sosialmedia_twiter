import 'package:flutter/foundation.dart';
import 'package:uas_twitter_mediasosial/auth/auth_service.dart';
import 'package:uas_twitter_mediasosial/database/database_service.dart';
import 'package:uas_twitter_mediasosial/models/user.dart';

import '../models/comment.dart';
import '../models/post.dart';

class DatabaseProvider extends ChangeNotifier {
  
  final _db = DatabaseService();
  final _auth = AuthService(); // Menggunakan DatabaseService

  Future<UserProfile?> getUserProfile(String uid) => _db.getUserFromFirebase(uid);


  Future<void>updateBio(String bio) => _db.updateUserBioInFirebase(bio);

  List<Post> _allPost = [];


  List<Post> get allPots => _allPost;

  Future<void> postMessage(String message) async {
    await _db.postMessageInFirebase(message);

    await loadAllPosts();
  }

  Future<void> loadAllPosts() async {
    final allPosts = await _db.getAllPostFromFirebase();

    _allPost = allPosts;

    initializeLikeMap();


    notifyListeners();
  }




  //
  List<Post> fillerUserPosts(String uid) {
    return _allPost.where((post) => post.uid == uid).toList();
  }


  Future<void> deletePost(String postId) async {
    await _db.deletePostFromFirebase(postId);

    await loadAllPosts();
  }




  //
  Map<String, int> _likeCounts = {

  };

  List<String> _likePosts = [];

  bool isPostLikedByCurrentUser(String postId) => _likePosts.contains(postId);

  int getLikeCount(String postId) => _likeCounts[postId]?? 0;

  void initializeLikeMap() {
    final currentUserID = _auth.getCurrentUid();

    _likePosts.clear();

    for (var post in _allPost) {
      _likeCounts[post.id] = post.likeCount;

      if (post.likeBy.contains(currentUserID)) {

        _likePosts.add(post.id);


      }
    }

  }

  //
  Future<void> toggleLike (String postId) async{

    final LikedPostsOriginal = _likePosts;
    final LikedCountsOriginal = _likeCounts;


    if (_likePosts.contains(postId)) {

      _likePosts.remove(postId);
      _likeCounts[postId] = (_likeCounts[postId]?? 0)-1;
    }else{
      _likePosts.add(postId);
      _likeCounts[postId] =  (_likeCounts[postId]?? 0)+1;
    }

    notifyListeners();


    try{
      await _db.toggleLikeInFirebase(postId);
    }

    catch(e) {
      _likePosts = LikedPostsOriginal;
      _likeCounts = LikedCountsOriginal;

      notifyListeners();
    }
  }
  


  final Map<String, List<Comment>> _comments = {};

List<Comment> getComments(String postId) => _comments[postId] ?? [];

Future<void> loadComments(String postId) async{

  final allComments = await _db.getCommentsFromFirebase(postId);

_comments[postId] = allComments;


  notifyListeners();
}


Future<void> addComment(String postId, message) async {
  await _db.addCommentInFirebase(postId, message);
  await loadComments(postId);
}


Future<void> deleteComment(String commentId, postId) async{
  await _db.deleteCommentInFirebase(commentId);
  await loadComments(postId);
}
}
