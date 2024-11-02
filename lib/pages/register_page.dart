
import 'package:flutter/material.dart';
import 'package:uas_twitter_mediasosial/auth/auth_service.dart';
import 'package:uas_twitter_mediasosial/components/my_loading_cirle.dart';
import 'package:uas_twitter_mediasosial/database/database_service.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = AuthService();
  final _db = DatabaseService();


  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPwController = TextEditingController();

  void register() async {
    final String name = nameController.text;
    final String email = emailController.text;
    final String pw = pwController.text;
    final String confirmPw = confirmPwController.text;

    if (pwController.text == confirmPwController.text) {
      showLoadingCircle(context);

      try {
        await _auth.registerEmailPassword(
          emailController.text,
          pwController.text,
        );

        if (mounted) hideLoadingCircle(context);

        // create and save user in database
        await _db.saveUserInfoInFirebase(
          name: nameController.text,
          email: emailController.text,
          );

      } catch (e) {
          if (mounted) hideLoadingCircle(context);

          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ),
              );
          }

      }
    }
    else{
       showDialog(
              context: context,
              builder: (context) =>const AlertDialog(
                title: Text("Password don't macth"),
              ),
              );
    }

    // Memeriksa jika semua field telah diisi
    if (email.isNotEmpty && name.isNotEmpty && pw.isNotEmpty && confirmPw.isNotEmpty) {
      // Memeriksa jika password dan konfirmasi password cocok
      if (pw == confirmPw) {
      } 
      }
    } 
      
  



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            
                // logo
                Icon(
                  Icons.lock_open_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
            
                const SizedBox(height: 50),
                //welcome
                Text("Lets create an account for you",
                style: TextStyle(color:  Theme.of(context).colorScheme.primary,
                fontSize: 16,
                ),
                ),
            
                              const SizedBox(height: 25),
            
            
                //email 
                MyTextField(
                  controller:nameController,
                  hinText: "Name", 
                  obscureText: false,
                  ),

                                const SizedBox(height: 10),
                MyTextField(
                  controller:emailController,
                  hinText: "Email", 
                  obscureText: false,
                  ),

                                const SizedBox(height: 10),

            
                //password
                 MyTextField(
                  controller:pwController,
                  hinText: "Password", 
                  obscureText: true,
                  ),
                                const SizedBox(height: 10),

            
                //password
                 MyTextField(
                  controller:confirmPwController,
                  hinText: "Confirm Password", 
                  obscureText: true,
                  ),

                        const SizedBox(height: 25),

            
                //register button
                MyButton(
                  onTap: register,
                   text: "Register",
                   ),

                   const SizedBox(height: 50),
            
                // not a member? register now
               // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already a member? ",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(" Login now",
                      style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        ),
    );
  }
}