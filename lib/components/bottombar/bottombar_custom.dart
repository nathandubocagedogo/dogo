import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;

  const CustomBottomAppBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      padding: const EdgeInsets.symmetric(horizontal: 4),
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
          bottomAppBarItem(3, Icons.account_circle, 'Profil'),
        ],
      ),
    );
  }

  Widget bottomAppBarItem(int index, IconData icon, String label) {
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () => onTap(index),
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: currentIndex == index ? Colors.orange : null,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: currentIndex == index ? Colors.orange : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
