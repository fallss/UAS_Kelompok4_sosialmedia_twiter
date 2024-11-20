import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_twitter_mediasosial/database/database_provider.dart';
import 'package:uas_twitter_mediasosial/pages/my_user_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    //provider
    final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    final listeningProvider = Provider.of<DatabaseProvider>(context);


    return Scaffold(
      appBar:AppBar(
        title: TextField(
          controller:_searchController ,
          decoration: InputDecoration(
            hintText: "Search users....",
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            border: InputBorder.none,
          ),
          onChanged:(value) {
            if(value.isNotEmpty){
              databaseProvider.searchUsers(value);
            }
            else{
              databaseProvider.searchUsers("");
            }

          },
        ),
      ) ,
      backgroundColor: Theme.of(context).colorScheme.surface,
      
      body: listeningProvider.searchResults.isEmpty ?
      //no users found
      const Center(child: Text("No Users Found...."),)
      :


      ListView.builder(
        itemCount:listeningProvider.searchResults.length ,
        itemBuilder: (context,index){
          final user = listeningProvider.searchResults[index];

          return MyUserTile(user: user);


        },
      )
    );
  }
}