import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;

  const MyDrawerTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Gradien warna navy
    LinearGradient navyGradient = LinearGradient(
      colors: [
        Colors.blueAccent, // Navy
        Colors.blueAccent, // Medium Blue
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return ListTile(
      leading: ShaderMask(
        shaderCallback: (bounds) => navyGradient.createShader(bounds),
        child: Icon(
          icon,
          size: 28,
          color: Colors.white, // Warna putih untuk menerapkan gradien
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}
