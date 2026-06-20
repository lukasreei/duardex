import 'package:flutter/material.dart';

class LunaBottomNav extends StatelessWidget {
  const LunaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onChanged,
      height: 68,
      backgroundColor: const Color(0xFF0B0B10),
      indicatorColor: const Color(0x33FF6B9A),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.timeline_outlined),
          selectedIcon: Icon(Icons.timeline_rounded),
          label: 'Tempo',
        ),
        NavigationDestination(
          icon: Icon(Icons.mail_outline_rounded),
          selectedIcon: Icon(Icons.mail_rounded),
          label: 'Carta',
        ),
      ],
    );
  }
}
