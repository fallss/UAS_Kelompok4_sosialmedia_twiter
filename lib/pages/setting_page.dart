import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_twitter_mediasosial/components/my_setting_tile.dart';
//import 'package:uas_twitter_mediasosial/main.dart';
import 'package:uas_twitter_mediasosial/themes/theme_provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  //UI
  @override
  Widget build(BuildContext context) {
    //SCAFFOLD
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,

        //APP BAR
        centerTitle: true,
        title: const Text("S E T T I N G S"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      // body
      body: Column(
        children: [
          //dark mode
         MySettingsTile(
          title: "Dark Mode",
          action:  CupertinoSwitch(
              onChanged: (value) =>
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
              value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
            ),
          ),
          
          //block
        ],
      ),
    );
  }
}
