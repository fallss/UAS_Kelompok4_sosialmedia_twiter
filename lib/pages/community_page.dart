import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('C O M M U N I T Y'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Discover new Communities',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          _buildCommunityTile('Tectone\'s Degens', '17.4K Members'),
          _buildCommunityTile('Zenless Zone Zero (ZZZ)', '3,672 Members', 'Gaming'),
          _buildCommunityTile('Hoyoverse Games', '1,469 Members'),
          const SizedBox(height: 20.0),
          const Center(
            child: Text(
              'Show more',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityTile(String name, String members, [String? category]) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey[300],
      ),
      title: Text(
        name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(category != null ? '$members • $category' : members),
    );
  }
}