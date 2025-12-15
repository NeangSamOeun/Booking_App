// home_screen.dart

import 'package:booking_app/widgets/search_card.dart';
import 'package:flutter/material.dart';
// 1. RE-IMPORT the core widget needed for the screen
// import 'widgets/search_card.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for the overall screen
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            
            // 2. RE-ENABLE the SearchCard
            Transform.translate(
              offset: const Offset(0, -30), // Negative margin for overlap effect
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SearchCard(), // Contains search fields and journey details
              ),
            ),
            
            // Add a padding to the bottom so the last content isn't cut off by the BottomNavBar
            const SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }

  // --- Header Structure ---
  Widget _buildHeader(BuildContext context) {
    const double headerHeight = 180; // Slightly taller to fit the bus graphic better

    return Container(
      height: headerHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red[400], // Primary Header Color
      ),
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, left: 20, right: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Greeting Text (Aligned left/center)
          const Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Hey John!', style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
                Text('Where you want go.', style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                )),
              ],
            ),
          ),
          
          // User Profile Image (Top Right - Based on image_45e9b8.png)
          const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                // Replace with actual image asset if available
                child: Icon(Icons.person, color: Colors.red), 
              ),
            ),
          ),
          
          // Custom Bus Graphic (Simulating the 'Bus in the clouds' effect)
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 25), // Push slightly above the bottom edge
              child: _BusInCloudsGraphic(),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Custom Widget to replicate the stylized bus graphic ---
class _BusInCloudsGraphic extends StatelessWidget {
  const _BusInCloudsGraphic();

  @override
  Widget build(BuildContext context) {
    return Container(
      // The overall size of the graphic area
      width: 80,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cloud Base (Simulated)
          Transform.translate(
            offset: const Offset(0, 15),
            child: Icon(Icons.cloud, color: Colors.white.withOpacity(0.4), size: 70),
          ),
          // Bus Icon (The main element)
          Icon(
            Icons.directions_bus, 
            color: Colors.red[100], // Lighter color for stylized look
            size: 45,
          ),
        ],
      ),
    );
  }
}