import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/search_card.dart';

/// ================= APP COLORS =================
class AppColors {
  static const primary = Color(0xFFE53935);
  static const primaryLight = Color(0xFFEF5350);
  static const background = Color(0xFFF5F5F5);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String lastName = '';

  @override
  void initState() {
    super.initState();
    _loadLastName();
  }

  Future<void> _loadLastName() async {
    try {
      final user = await AuthService().getCurrentUser();
      if (user != null && mounted) {
        setState(() {
          lastName = user.lastName;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _Header(lastName: lastName),
            Transform.translate(
              offset: const Offset(0, -36),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SearchCard(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// ================= HEADER =================
class _Header extends StatelessWidget {
  final String lastName;

  const _Header({required this.lastName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 18,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: Stack(
        children: [
          /// ---------- GREETING ----------
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, ${lastName.isNotEmpty ? lastName : 'Traveler'} 👋',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Where would you like to go today?',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          /// ---------- PROFILE ----------
          Positioned(
            top: 0,
            right: 0,
            child: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 23,
                backgroundColor: AppColors.primaryLight,
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          /// ---------- GRAPHIC ----------
          const Positioned(
            bottom: 18,
            left: 0,
            right: 0,
            child: Center(
              child: _BusInCloudsGraphic(),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= GRAPHIC =================
class _BusInCloudsGraphic extends StatelessWidget {
  const _BusInCloudsGraphic();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.cloud,
            size: 95,
            color: Colors.white.withOpacity(0.25),
          ),
          Icon(
            Icons.directions_bus,
            size: 46,
            color: Colors.white.withOpacity(0.95),
          ),
        ],
      ),
    );
  }
}
