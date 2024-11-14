import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  List<Post> _followingPosts = [];


  List<Post> get allPots => _allPost;
  List<Post> get followingPosts => _followingPosts;

  Future<void> postMessage(String message) async {
    await _db.postMessageInFirebase(message);

    await loadAllPosts();
  }


  Future<void> loadAllPosts() async {
    final allPosts = await _db.getAllPostFromFirebase();

    _allPost = allPosts;

    loadFollowingPosts();


    initializeLikeMap();


    notifyListeners();
  }




  //
  List<Post> fillerUserPosts(String uid) {
    return _allPost.where((post) => post.uid == uid).toList();
  }

  //load following posts 
  Future<void> loadFollowingPosts() async {
    //get current uid
    String currentUid = _auth.getCurrentUid();

    //get list of uids 
    final followingUserIds = await _db.getFollowingUidFromFirebase(currentUid);

    //filter all the post
    _followingPosts = _allPost.where((post) => followingUserIds.contains(post.uid)).toList();

    //update ui
    notifyListeners();
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


final Map<String, List<String>> _followers = {};
final Map<String, List<String>> _following = {};
final Map<String, int> _followerCount = {};
final Map<String, int> _followingCount = {};

int getFollowerCount(String uid) => _followerCount[uid] ?? 0;
int getFollowingCount(String uid) => _followingCount[uid] ?? 0;

Future<void> loadUserFollowers(String uid) async {
  final listOfFollowersUid = await _db.getFollowerUidFromFirebase(uid);

  _followers[uid] = listOfFollowersUid;
  _followerCount[uid] = listOfFollowersUid.length;

  notifyListeners();
}

Future<void> loadUserFollowing(String uid) async {
  final listOfFollowingUids = await _db.getFollowingUidFromFirebase(uid); // memastikan pemanggilan fungsi yang benar

  _following[uid] = listOfFollowingUids;
  _followingCount[uid] = listOfFollowingUids.length;

  notifyListeners();
}

Future<void> followUser(String targetUserId) async {
  final currentUserId = _auth.getCurrentUid();

  _following.putIfAbsent(currentUserId, () => []);
  _followers.putIfAbsent(targetUserId, () => []);

  if (!_followers[targetUserId]!.contains(currentUserId)) {
    _followers[targetUserId]?.add(currentUserId);
    _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) + 1;

    _following[currentUserId]?.add(targetUserId);
    _followingCount[currentUserId] = (_followingCount[currentUserId] ?? 0) + 1;
  }

  notifyListeners();

  try {
    await _db.followUserInFirebase(targetUserId);
    await loadUserFollowers(currentUserId);
    await loadUserFollowing(currentUserId);
  } catch (e) {
    _followers[targetUserId]?.remove(currentUserId);
    _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) - 1;

    _following[currentUserId]?.remove(targetUserId);
    _followingCount[currentUserId] = (_followingCount[currentUserId] ?? 0) - 1;

    notifyListeners();
  }
}

Future<void> unfollowUser(String targetUserId) async {
  final currentUserId = _auth.getCurrentUid();

  _following.putIfAbsent(currentUserId, () => []);
  _followers.putIfAbsent(targetUserId, () => []);

  if (_followers[targetUserId]!.contains(currentUserId)) {
    _followers[targetUserId]?.remove(currentUserId);
    _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) - 1;

    _following[currentUserId]?.remove(targetUserId); // Memastikan yang dihapus adalah target user dari current user
    _followingCount[currentUserId] = (_followingCount[currentUserId] ?? 0) - 1;
  }
  
  notifyListeners();

  try {
    await _db.unfollowUserInFirebase(targetUserId);
    await loadUserFollowers(currentUserId);
    await loadUserFollowing(currentUserId);
  } catch (e) {
    _followers[targetUserId]?.add(currentUserId);
    _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) + 1;

    _following[currentUserId]?.add(targetUserId);
    _followingCount[currentUserId] = (_followingCount[currentUserId] ?? 0) + 1;

    notifyListeners();
  }
}

bool isFollowing(String uid) {
  final currentUserId = _auth.getCurrentUid();
  return _following[currentUserId]?.contains(uid) ?? false; // menggunakan ?? false agar defaultnya tidak mengikuti
}

void userProfile(String uid) {}

final Map<String, List<UserProfile>> _followersProfile = {};
final Map<String, List<UserProfile>> _followingProfile = {};

//
List<UserProfile> getListOfFollowerProfile(String uid) => 
_followersProfile[uid] ?? [];

List<UserProfile> getListOfFollowingProfile(String uid) => 
_followingProfile[uid] ?? [];

Future<void> loadUserFollowerProfiles(String uid) async {
  try {
    // get list from firebase
    final followerIds = await _db.getFollowerUidFromFirebase(uid);

    // create list of user profiles
    List<UserProfile> followerProfiles = [];

    // go through follower IDs
    for (String followerId in followerIds) {
      // get user from firebase
      UserProfile? followerProfile = await _db.getUserFromFirebase(followerId);

      // add to follower profiles
      if (followerProfile != null) {
        followerProfiles.add(followerProfile);
      }
    }

    // update local data
    _followersProfile[uid] = followerProfiles;

    // update UI
    notifyListeners();
  } catch (e) {
    // handle errors here
    print(e);
  }
}

Future<void>loadUserFollowingProfiles(String uid) async {
  try {
    // get list from firebase
    final followingIds = await _db.getFollowingUidFromFirebase(uid);

    // create list of user profiles
    List<UserProfile> followingProfiles = [];

    // go through follower IDs
    for (String followingId in followingIds) {
      // get user from firebase
      UserProfile? followingProfile = await _db.getUserFromFirebase(followingId);

      // add to follower profiles
      if (followingProfile != null) {
        followingProfiles.add(followingProfile);
      }
    }

    // update local data
    _followingProfile[uid] = followingProfiles;

    // update UI
    notifyListeners();
  } catch (e) {
    // handle errors here
    print(e);
  }
}


}