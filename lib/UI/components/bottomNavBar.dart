import 'package:flutter/material.dart';
// bottomNavBar.dart
class CustomBottomNavBar extends StatelessWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;

  CustomBottomNavBar({
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemSelected,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_rounded),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Menu',
        ),
      ],
    );
  }
}
