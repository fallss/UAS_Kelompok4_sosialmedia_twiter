import 'package:flutter/foundation.dart';
import 'package:uas_twitter_mediasosial/database/database_service.dart';
import 'package:uas_twitter_mediasosial/models/user.dart';

import '../models/post.dart';

class DatabaseProvider extends ChangeNotifier {
  final _db = DatabaseService(); // Menggunakan DatabaseService

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


    notifyListeners();
  }




  //
  List<Post> fillerUserPosts(String uid) {
    return _allPost.where((post) => post.uid == uid).toList();
  }
}
