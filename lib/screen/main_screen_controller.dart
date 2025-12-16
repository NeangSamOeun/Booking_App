import 'package:booking_app/screen/setting_screen.dart';
import 'package:booking_app/screen/tickets_screen.dart';
import 'package:booking_app/screen/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart'; // The home screen content

class MainScreenController extends StatefulWidget {
  const MainScreenController({super.key});

  @override
  State<MainScreenController> createState() => _MainScreenControllerState();
}

class _MainScreenControllerState extends State<MainScreenController> {
  int _currentIndex = 0; // Tracks the selected tab index

  // List of all screens corresponding to the navigation bar
  final List<Widget> _screens = const [
    HomeScreen(),        // 0: The primary Home screen
    TicketsScreen(),     // 1: Tickets Placeholder
    WalletScreen(),      // 2: Wallet Placeholder
    SettingScreen(),     // 3: Setting Placeholder
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // --- Bottom Navigation Bar Widget ---
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.red[400],
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
      onTap: _onTap, 
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Tickets',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'Wallet',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Setting',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }
}