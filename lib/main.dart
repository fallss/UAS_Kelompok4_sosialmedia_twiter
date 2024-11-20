import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_twitter_mediasosial/database/database_provider.dart';
import 'package:uas_twitter_mediasosial/firebase_options.dart';
import 'package:uas_twitter_mediasosial/introduction_screen.dart';
import 'package:uas_twitter_mediasosial/themes/theme_provider.dart';
void main() async{

  //firebase 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),


        ChangeNotifierProvider(create: (context) => DatabaseProvider()),

      ],
      child:const MyApp(),
      ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:IntroductionScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );

  }
} 