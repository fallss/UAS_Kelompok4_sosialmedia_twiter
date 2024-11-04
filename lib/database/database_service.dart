import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_twitter_mediasosial/auth/auth_service.dart';
import 'package:uas_twitter_mediasosial/models/user.dart';

import '../models/post.dart';

class DatabaseService {
  final  _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;



  // User profile
  //save user info
  Future<void> saveUserInfoInFirebase(
    {required String name,required String email}) async{
String uid = _auth.currentUser!.uid;

String username = email.split('@')[0];


UserProfile user = UserProfile(
  uid: uid,
  name: name,
  email : email,
  username: username,
  bio: '',
  );

  final userMap = user.toMap();


  await _db.collection("Users").doc(uid).set(userMap);

  }


//get user info
Future<UserProfile?> getUserFromFirebase(String uid) async {
  try {


    DocumentSnapshot userDoc = await _db.collection("Users").doc(uid).get();


    return UserProfile.fromDocument(userDoc);
  }catch (e) {
    print(e);
    return null;
  }
}


//upfate user bio
Future<void> updateUserBioInFirebase(String bio) async{
  String uid = AuthService().getCurrentUid();

  try {
    await _db.collection("Users").doc(uid).update({'bio' :bio});
  }catch (e) {
    print(e);
  }
}


// post a message
Future<void> postMessageInFirebase(String message) async{
  try{
    String uid = _auth.currentUser!.uid;

    UserProfile? user = await getUserFromFirebase(uid);

    //create a new post
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

  }
  catch (e){
    print(e);
  }
}



Future<List<Post>> getAllPostFromFirebase() async {

  try {
    QuerySnapshot snapshot = await _db
    .collection("Post")
    .orderBy('timestamp', 
    descending: true)
    .get();
    return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
  }
  catch (e) {
    return [];
  }
}


}