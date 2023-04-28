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
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => onTap(0),
            icon: const Icon(
              Icons.home,
            ),
          ),
          IconButton(
            onPressed: () => onTap(1),
            icon: const Icon(Icons.home),
          ),
          const SizedBox(
            width: 48,
          ),
          IconButton(
            onPressed: () => onTap(2),
            icon: const Icon(
              Icons.group,
            ),
          ),
          IconButton(
            onPressed: () => onTap(3),
            icon: const Icon(
              Icons.group,
            ),
          ),
        ],
      ),
    );
  }
}
