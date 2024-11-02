import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  User? getCurrentUser() => _auth.currentUser;
  String getCurrentUid() => _auth.currentUser!.uid;

  Future<UserCredential> loginEmailPassword(String email, password) async {
await Future.delayed(const Duration(seconds: 2));

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    }
    on FirebaseException catch (e) {
     throw Exception(e.code);
    }
  }

  Future<UserCredential> registerEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth
      .createUserWithEmailAndPassword(
        email: email, 
        password: password,
        );
        return userCredential;
    } 
    on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> logout() async {
  await _auth.signOut();
}

}
