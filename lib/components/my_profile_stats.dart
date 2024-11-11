import 'package:flutter/material.dart';

class MyProfileStats extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;
  final void Function()? onTap;
  const MyProfileStats({
    super.key,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var TextStyleForCount = TextStyle(
        fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary);
    var TextStyleForText =
        TextStyle(color: Theme.of(context).colorScheme.primary);

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(postCount.toString(), style: TextStyleForCount),
                Text("Posts", style: TextStyleForText)
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(followerCount.toString(), style: TextStyleForCount),
                Text("Followers", style: TextStyleForText)
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(followingCount.toString(), style: TextStyleForCount),
                Text("Following", style: TextStyleForText)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
