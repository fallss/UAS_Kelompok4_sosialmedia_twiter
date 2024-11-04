




import 'package:flutter/material.dart';
import 'package:uas_twitter_mediasosial/auth/auth_service.dart';
import 'package:uas_twitter_mediasosial/components/my_loading_cirle.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class LoginPage extends StatefulWidget {
 // final void Function()? togglePages;
  final VoidCallback? onTap;
  const LoginPage({super.key, required this.onTap});
  

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
final _auth = AuthService();

final emailController = TextEditingController();
final pwController = TextEditingController();

void login() async{
  final String email = emailController.text;
  final String pw = pwController.text;

showLoadingCircle(context);

  try {
    await _auth.loginEmailPassword(emailController.text, pwController.text);

    // finish loading
    if (mounted) hideLoadingCircle(context);
  }
  catch (e){

        if (mounted) hideLoadingCircle(context);

      
      //  if (mounted) {
      //       showDialog(
      //         context: context,
      //         builder: (context) => AlertDialog(
      //           title: Text(e.toString()),
      //         ),
      //         );
      //     }

  }


  //  email pw not empty
  if (email.isNotEmpty && pw.isNotEmpty) {
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter both email and password')),
    );
  }
}


@override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
    super.dispose();
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
                Text("Welcome back, you've been missed!",
                style: TextStyle(color:  Theme.of(context).colorScheme.primary,
                fontSize: 16,
                ),
                ),
            
                              const SizedBox(height: 25),
            
            
                //email 
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

                        const SizedBox(height: 25),

            
                //login button
                MyButton(
                  onTap: login,
                   text: "Login",
                   ),

                   const SizedBox(height: 50),
            
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member? ",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(" Register now",
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
