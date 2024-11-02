import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_twitter_mediasosial/auth/auth_service.dart';
import 'package:uas_twitter_mediasosial/database/database_provider.dart';
import 'package:uas_twitter_mediasosial/models/user.dart';



class ProfilePage extends StatefulWidget {
final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
late final databaseProvider =
 Provider.of<DatabaseProvider>(context, listen: false);

 // user info
 UserProfile? user;
 String currentUserId = AuthService().getCurrentUid();

 bool _isLoading = true;

 @override
  void initState() {
    super.initState();

    //
    loadUser();
  }

Future<void> loadUser() async{
  user = await databaseProvider.getUserProfile(widget.uid);

  setState(() {
    _isLoading = false;
  });
}
  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface ,
      appBar: AppBar(
        centerTitle: true,
        title: Text(_isLoading ? '' : user!.name),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),


      body:ListView(
        children: [
          Center(
            child: Text(_isLoading ? '' : '@${user!.username}',
            style:TextStyle(color:Theme.of(context).colorScheme.primary),
             ),
          ),

          const SizedBox(height: 25),

          //profile 
          Center(
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(25),
              ),
              
              padding:const EdgeInsets.all(25),
              child: Icon(
                Icons.person,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
                ),
            ),
          ),
          const SizedBox(height: 25),


        ],
      )
    );
  }
}
