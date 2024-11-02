import 'package:flutter/foundation.dart';
import 'package:uas_twitter_mediasosial/auth/auth_service.dart';
import 'package:uas_twitter_mediasosial/database/database_service.dart';
import 'package:uas_twitter_mediasosial/models/user.dart';

class DatabaseProvider extends ChangeNotifier {
  final _auth = AuthService();
  final _db = DatabaseService(); // Menggunakan DatabaseService

  Future<UserProfile?> getUserProfile(String uid) => _db.getUserFromFirebase(uid);
}
