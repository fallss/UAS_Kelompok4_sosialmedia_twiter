import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_twitter_mediasosial/database/database_provider.dart';
import 'package:uas_twitter_mediasosial/models/user.dart';
import 'package:uas_twitter_mediasosial/pages/my_user_tile.dart';

class FollowListPage extends StatefulWidget {
  final String uid;

  const FollowListPage({super.key, required this.uid}); 

  @override
  State<FollowListPage> createState() => _FollowListPageState();
}

class _FollowListPageState extends State<FollowListPage> {
  //providers
  late DatabaseProvider listeningProvider = Provider.of<DatabaseProvider>(context);
  late DatabaseProvider databaseProvider = 
        Provider.of<DatabaseProvider>(context,listen: false);
  
  @override
  void initState() {
    super.initState();
    //load follower list
    loadFollowerList();
    //load following list
    loadFollowingList();
  }
//load follower
Future<void> loadFollowerList() async{
  await databaseProvider.loadUserFollowerProfiles(widget.uid);
}
Future<void> loadFollowingList() async{
  await databaseProvider.loadUserFollowingProfiles(widget.uid);
}
  @override
  Widget build(BuildContext context) {
    listeningProvider = Provider.of<DatabaseProvider>(context);

    final followers = listeningProvider.getListOfFollowerProfile(widget.uid);
    final following = listeningProvider.getListOfFollowingProfile(widget.uid);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: "Followers"),
              Tab(text: "Following"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserList(followers, "No Followers.."),
            _buildUserList(following, "No Following.."),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(List<UserProfile> userList, String emptyMessage) {
    return userList.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              return MyUserTile(user: user,);
            },
          );
  }
}
