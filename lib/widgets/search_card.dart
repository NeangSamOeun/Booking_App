// widgets/search_card.dart

import 'package:booking_app/screen/find_buses_screen.dart';
import 'package:booking_app/widgets/upcoming_journey_card.dart';
import 'package:flutter/material.dart';
// import 'upcoming_journey_card.dart'; // Import the dependency

class SearchCard extends StatelessWidget {
  const SearchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      // Rounded corners matching the image style
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.orange[700], // The prominent orange background color
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. BOARDING/DESTINATION FIELDS ---
            Stack(
              clipBehavior: Clip.none,
              children: [
                const Column(
                  children: [
                    // Field 1: Boarding From
                    _InputField(label: 'Boarding From', hint: 'Type City/Locality'), 
                    SizedBox(height: 10),
                    // Field 2: Where are you going?
                    _InputField(label: 'Where are you going?', hint: 'Type City/Locality'),
                  ],
                ),
                
                // Swap Button: Positioned perfectly between the two fields
                Positioned(
                  right: 15,
                  top: 45,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange.shade700!, width: 3),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Icon(Icons.swap_vert, color: Colors.red[400], size: 20),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),

            // --- 2. DATE SELECTION ROW ---
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _DateButton(label: 'Today', isSelected: true),
                _DateButton(label: 'Tomorrow', isSelected: false),
                _DateButton(label: 'Other', icon: Icons.calendar_month, isSelected: false),
              ],
            ),
            
            const SizedBox(height: 25),

            // --- 3. FIND BUSES BUTTON ---
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FindBusesScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400], // Red color matching the header
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                elevation: 0,
              ),
              child: const Text(
                'Find Buses',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 30), // Separator for the embedded section
            
            // --- 4. EMBEDDED UPCOMING JOURNEY ---
            const Text(
              'Upcoming Journey',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold, 
                color: Colors.white // White text for title on orange background
              ),
            ),
            const SizedBox(height: 10),

            // The inner card is white and contains all journey details
            const UpcomingJourneyCard(isEmbedded: true), 
          ],
        ),
      ),
    );
  }
}

// --- HELPER WIDGETS ---

class _InputField extends StatelessWidget {
  final String label;
  final String hint;

  const _InputField({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Using a simple Text here to match the non-editable look in the image
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)), 
        ],
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;

  const _DateButton({required this.label, this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        // Toggle background color based on selection
        color: isSelected ? Colors.white : Colors.orange[600], 
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: isSelected ? Colors.black : Colors.white),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              // Toggle text color based on selection
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}