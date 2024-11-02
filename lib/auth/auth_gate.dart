import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uas_twitter_mediasosial/auth/login_or_register.dart';
import 'package:uas_twitter_mediasosial/pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {

          if (snapshot.hasData) {
            return const HomePage();
          }
          else {
            return const LoginOrRegister();
          }
        },
        ),
    );
  }
}