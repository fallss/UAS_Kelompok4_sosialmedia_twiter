import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String username;
  final String bio;

  UserProfile({
    required this.uid,
    required this.bio,
    required this.name,
    required this.email,
    required this.username,
  });

  // firetore to user
  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    return UserProfile(
      uid: doc ['uid'],
      bio:  doc ['bio'] ,
      name: doc ['name'] ,
       email:doc ['email'] ,
       username: doc ['username']
    );
  }


Map<String, dynamic> toMap() {
  return{
'uid': uid,
'name':name,
'email': email,
'username': username,
'bio' : bio,
  };
}



}