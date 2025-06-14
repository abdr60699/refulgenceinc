import 'package:flutter/material.dart';

import '../screens/favourite_screen.dart';

class ProductListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onLogout;

  const ProductListAppBar({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      title: const Text(
        'Discover Products',
        style: TextStyle(fontSize: 18),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FavoritesScreen(),
              ),
            );
          },
        ),
        IconButton(
          onPressed: onLogout,
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}