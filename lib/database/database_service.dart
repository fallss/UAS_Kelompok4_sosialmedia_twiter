import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_twitter_mediasosial/auth/auth_service.dart';
import 'package:uas_twitter_mediasosial/models/comment.dart';
import 'package:uas_twitter_mediasosial/models/user.dart';
import '../models/post.dart';

class DatabaseService {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserInfoInFirebase(
      {required String name, required String email}) async {
    String uid = _auth.currentUser!.uid;
    String username = email.split('@')[0];

    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      bio: '',
    );

    final userMap = user.toMap();
    await _db.collection("Users").doc(uid).set(userMap);
  }

  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection("Users").doc(uid).get();
      return UserProfile.fromDocument(userDoc);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> updateUserBioInFirebase(String bio) async {
    String uid = AuthService().getCurrentUid();
    try {
      await _db.collection("Users").doc(uid).update({'bio': bio});
    } catch (e) {
      print(e);
    }
  }

  Future<void> postMessageInFirebase(String message) async {
    try {
      String uid = _auth.currentUser!.uid;
      UserProfile? user = await getUserFromFirebase(uid);

      Post newPost = Post(
        id: '',
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
        likeCount: 0,
        likeBy: [],
      );
      Map<String, dynamic> newPostMap = newPost.toMap();

      await _db.collection("Post").add(newPostMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePostFromFirebase(String postId) async {
    try {
      await _db.collection("Post").doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Post>> getAllPostFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection("Post")
          .orderBy('timestamp', descending: true)
          .get();
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> toggleLikeInFirebase(String postId) async {
    try {
      String uid = _auth.currentUser!.uid;

      DocumentReference postDoc = _db.collection("Post").doc(postId);

      await _db.runTransaction((transaction) async {
        DocumentSnapshot postSnapshot = await transaction.get(postDoc);

        List<String> likeBy = List<String>.from(postSnapshot['likeBy'] ?? []);
        int currentLikeCount = postSnapshot['likes'];

        if (!likeBy.contains(uid)) {
          likeBy.add(uid);
          currentLikeCount++;
        } else {
          likeBy.remove(uid);
          currentLikeCount--;
        }

        transaction.update(postDoc, {
          'likes': currentLikeCount,
          'likeBy': likeBy,
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addCommentInFirebase(String postId, String message) async {
    try {
      String uid = _auth.currentUser!.uid;
      UserProfile? user = await getUserFromFirebase(uid);

      Comment newComment = Comment(
        id: '',
        postId: postId,
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
      );

      Map<String, dynamic> newCommentMap = newComment.toMap();

      await _db.collection("Comments").add(newCommentMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteCommentInFirebase(String commentId) async {
    try {
      await _db.collection("Comments").doc(commentId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Comment>> getCommentsFromFirebase(String postId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection("Comments")
          .where("postId", isEqualTo: postId)
          .get();

      return snapshot.docs.map((doc) => Comment.fromDocument(doc)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> followUserInfirebasse(String uid) async {
    final currentUSerId = _auth.currentUser!.uid;

    await _db
        .collection("Users")
        .doc(currentUSerId)
        .collection("Following")
        .doc(uid)
        .set({});

    await _db
        .collection("Users")
        .doc(uid)
        .collection("Followers")
        .doc(currentUSerId)
        .set({});
  }

  Future<void> unFollowUserInFirebase(String uid) async {
    final currentUSerId = _auth.currentUser!.uid;

    await _db
        .collection("Users")
        .doc(currentUSerId)
        .collection("Following")
        .doc(uid)
        .delete();

    await _db
        .collection("Users")
        .doc(uid)
        .collection("Followers")
        .doc(currentUSerId)
        .delete();
  }

  Future<void> followUserInFirebase(String uid) async {
  final currentUserId = _auth.currentUser!.uid;

  await _db
      .collection("Users")
      .doc(currentUserId)
      .collection("Following")
      .doc(uid)
      .set({});

  await _db
      .collection("Users")
      .doc(uid)
      .collection("Followers")
      .doc(currentUserId)
      .set({});
}

Future<void> unfollowUserInFirebase(String uid) async {
  final currentUserId = _auth.currentUser!.uid;

  await _db
      .collection("Users")
      .doc(currentUserId)
      .collection("Following")
      .doc(uid)
      .delete();

  await _db
      .collection("Users")
      .doc(uid)
      .collection("Followers")
      .doc(currentUserId)
      .delete();
}

Future<List<String>> getFollowerUidFromFirebase(String uid) async {
  final snapshot =
      await _db.collection("Users").doc(uid).collection("Followers").get();

  return snapshot.docs.map((doc) => doc.id).toList();
}

Future<List<String>> getFollowingUidFromFirebase(String uid) async {
  final snapshot =
      await _db.collection("Users").doc(uid).collection("Following").get();

  return snapshot.docs.map((doc) => doc.id).toList();
}

}
