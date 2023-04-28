import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;

  const CustomBottomAppBar({
    Key? key,
    required this.onTap,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          bottomAppBarItem(0, Icons.home, 'Accueil'),
          bottomAppBarItem(1, Icons.group, 'Groupes'),
          const SizedBox(
            width: 48,
          ),
          bottomAppBarItem(2, Icons.bookmark, 'Favoris'),
          bottomAppBarItem(3, Icons.settings, 'Paramètres'),
        ],
      ),
    );
  }

  Widget bottomAppBarItem(int index, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => onTap(index),
          icon: Icon(
            icon,
            color: currentIndex == index ? Colors.orange : null,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: currentIndex == index ? Colors.orange : null,
          ),
        ),
      ],
    );
  }
}
