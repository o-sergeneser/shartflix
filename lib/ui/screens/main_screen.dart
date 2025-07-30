import 'package:flutter/material.dart';
import 'package:shartflix/ui/screens/home/home_screen.dart';
import 'package:shartflix/ui/screens/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          final inFromRight = Tween<Offset>(
            begin: const Offset(1.0, 0.0), 
            end: Offset.zero,
          ).animate(animation);

          return SlideTransition(position: inFromRight, child: child);
        },
        child: _getPage(_selectedIndex), 
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Anasayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomeScreen(key: ValueKey(0));
      case 1:
        return const ProfileScreen(key: ValueKey(1));
      default:
        return const SizedBox.shrink();
    }
  }
}
