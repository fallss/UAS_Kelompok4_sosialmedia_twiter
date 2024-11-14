import 'package:flutter/material.dart';
import 'package:uas_twitter_mediasosial/models/user.dart';
import 'package:uas_twitter_mediasosial/pages/profile_page.dart';


class MyUserTile extends StatelessWidget {
  final UserProfile user;

  const MyUserTile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),

      // padding inside
      padding: const EdgeInsets.all(5), // Tambahkan koma di sini

      decoration: BoxDecoration(
        // color tile
        color: Theme.of(context).colorScheme.secondary,

        // curve corners
        borderRadius: BorderRadius.circular(8),
      ),

      child: ListTile(
        title: Text(user.name),
        subtitle: Text('@${user.name}'), // Tambahkan koma di sini
        leading: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: () => Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProfilePage(uid: user.uid)
        ),
        ),

        //arrow forward icon
        trailing: Icon(Icons.arrow_forward,color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
