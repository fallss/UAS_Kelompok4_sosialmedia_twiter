import 'package:flutter/material.dart';

import '../models/post.dart';

class MyPostTile extends StatefulWidget {

  final Post post;
  
  const MyPostTile({
    super.key,
    required this.post,
    });

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {


  //UI
  @override
  Widget build(BuildContext context) {
    return Container(

      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,

        borderRadius: BorderRadius.circular(8),
      ),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(width: 10),

              Text(widget.post.name,
              style: TextStyle(color: Theme.of(context).colorScheme.primary,
              fontWeight : FontWeight.bold,

              ),
              ),

              const SizedBox(width: 5),

              Text(
               '@${widget.post.username}',
                style: TextStyle(
                color: Theme.of(context).colorScheme.primary
                ),
              ),
            ],
          ),

              const SizedBox(height: 20),


          Text(
            widget.post.message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ],
      ),
    );
  }
}