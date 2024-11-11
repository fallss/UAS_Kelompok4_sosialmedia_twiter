import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_twitter_mediasosial/auth/auth_service.dart';
import 'package:uas_twitter_mediasosial/components/my_bio_box.dart';
import 'package:uas_twitter_mediasosial/components/my_follow_button.dart';
import 'package:uas_twitter_mediasosial/components/my_input_alert_box.dart';
import 'package:uas_twitter_mediasosial/components/my_post_tile.dart';
import 'package:uas_twitter_mediasosial/components/my_profile_stats.dart';
import 'package:uas_twitter_mediasosial/database/database_provider.dart';
import 'package:uas_twitter_mediasosial/models/user.dart';

import '../helper/navigate_pages.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // user info
  UserProfile? user;
  String currentUserId = AuthService().getCurrentUid();

  final bioTextController = TextEditingController();

  bool _isLoading = true;

  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();

    //
    loadUser();
  }

  Future<void> loadUser() async {
    user = await databaseProvider.getUserProfile(widget.uid);

    await databaseProvider.loadUserFollowers(widget.uid);
    await databaseProvider.loadUserFollowing(widget.uid);

    _isFollowing = databaseProvider.isFollowing(widget.uid);

    setState(() {
      _isLoading = false;
    });
  }

  void _showEditBioBox() {
    showDialog(
        context: context,
        builder: (context) => MyInputAlertBox(
            textController: bioTextController,
            hinText: "Edit bio..",
            onPressed: saveBio,
            onPressedText: "Save"));
  }

  Future<void> saveBio() async {
    setState(() {
      _isLoading = true;
    });

    await databaseProvider.updateBio(bioTextController.text);

    await loadUser();

    setState(() {
      _isLoading = false;
    });

    print("saving..");
  }

  Future<void> toggleFollow() async {
    if (_isFollowing) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Unfollow"),
          content: const Text("Are you sure want to unfollow?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                await databaseProvider.unfollowUser(widget.uid);
              },
              child: const Text("Yes"),
            ),
          ],
        ),
      );
    } else {
      await databaseProvider.followUser(widget.uid);
    }
    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  //UI
  @override
  Widget build(BuildContext context) {
    final allUserPosts = listeningProvider.fillerUserPosts(widget.uid);

    final followerCount =listeningProvider.getFollowerCount(widget.uid);
    final followingCount =listeningProvider.getFollowingCount(widget.uid);

    _isFollowing = listeningProvider.isFollowing(widget.uid);

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          centerTitle: true,
          title: Text(_isLoading ? '' : user!.name),
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: ListView(
          children: [
            Center(
              child: Text(
                _isLoading ? '' : '@${user!.username}',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),

            const SizedBox(height: 25),

            //profile
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(25),
                child: Icon(
                  Icons.person,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 25),

            MyProfileStats(
                postCount: allUserPosts.length,
                followerCount:followerCount,
                followingCount: followingCount,
                onTap: (){},
                ),

            //
            if (user != null && user!.uid != currentUserId)
              MyFollowButton(
                onPressed: toggleFollow,
                isFollowing: _isFollowing,
              ),

                          const SizedBox(height: 25),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bio",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: _showEditBioBox,
                    child: Icon(Icons.settings,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            //bio box
            MyBioBox(text: _isLoading ? '...' : user!.bio),

            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 25),
              child: Text(
                "posts",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),

            allUserPosts.isEmpty
                ? const Center(
                    child: Text("No posts yet.."),
                  )
                : ListView.builder(
                    itemCount: allUserPosts.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final post = allUserPosts[index];

                      return MyPostTile(
                        post: post,
                        onUserTap: () {},
                        onPostTap: () => goPostPage(context, post),
                      );
                    },
                  ),
          ],
        ));
  }
}
