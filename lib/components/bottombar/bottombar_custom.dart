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
          bottomAppBarItem(0, Icons.home, 'Accueil', context),
          bottomAppBarItem(1, Icons.group, 'Groupes', context),
          const SizedBox(
            width: 48,
          ),
          bottomAppBarItem(2, Icons.bookmark, 'Favoris', context),
          bottomAppBarItem(3, Icons.account_circle, 'Profil', context),
        ],
      ),
    );
  }

  Widget bottomAppBarItem(
      int index, IconData icon, String label, BuildContext context) {
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () => onTap(index),
        child: Container(
          padding: isAndroid
              ? const EdgeInsets.fromLTRB(0, 16, 0, 16)
              : const EdgeInsets.fromLTRB(0, 16, 0, 0),
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
