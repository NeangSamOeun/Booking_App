import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bus_model.dart';
import 'select_seat_screen.dart';
import 'addBusScreen.dart';

/// ================= THEME COLORS =================
class AppColors {
  static const primary = Color(0xFFE53935);
  static const background = Color(0xFFF8F9FA); // Slightly lighter grey
  static const textDark = Color(0xFF212121);
  static const textGrey = Color(0xFF757575);
  static const lowSeat = Color(0xFFD32F2F);
  static const availableSeat = Color(0xFF388E3C);
}

class FindBusesScreen extends StatelessWidget {
  const FindBusesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: kPrimaryRed,
        elevation: 0,
        centerTitle: true,
        title: const Text('Find Your Bus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Use 'startDate' to match your current Firebase field
        stream: FirebaseFirestore.instance
            .collection('buses')
            .orderBy('startDate', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bus_alert, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No buses available right now.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            );
          }

          final buses = snapshot.data!.docs.map((doc) {
            return BusModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: buses.length,
            itemBuilder: (context, index) => _BusCard(bus: buses[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddBusScreen()),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Bus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _BusCard extends StatelessWidget {
  final BusModel bus;
  const _BusCard({required this.bus});

  @override
  Widget build(BuildContext context) {
    // Determine seat availability status
    final bool isLowSeat = bus.availableSeats <= 5 && bus.availableSeats > 0;
    final bool isFull = bus.availableSeats == 0;
    
    // Formatting the date
    final String dateStr = "${bus.startDate.day.toString().padLeft(2, '0')}/${bus.startDate.month.toString().padLeft(2, '0')}/${bus.startDate.year}";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Operator Name and Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      bus.operator,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    ),
                    Text(
                      '\$${bus.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
                Text(bus.busType, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                
                const SizedBox(height: 16),

                // Route Visualization
                Row(
                  children: [
                    _locationColumn(bus.departure, "Departure"),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.radio_button_checked, size: 12, color: AppColors.primary),
                            Expanded(child: Divider(color: AppColors.primary, thickness: 1)),
                            Icon(Icons.directions_bus, size: 20, color: AppColors.primary),
                            Expanded(child: Divider(color: AppColors.primary, thickness: 1)),
                            Icon(Icons.location_on, size: 12, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                    _locationColumn(bus.arrival, "Arrival"),
                  ],
                ),

                const SizedBox(height: 16),

                // Date and Duration
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: AppColors.textGrey),
                        const SizedBox(width: 4),
                        Text(dateStr, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: AppColors.textGrey),
                        const SizedBox(width: 4),
                        Text(bus.duration, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Action Section (Bottom of Card)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isFull ? 'FULLY BOOKED' : '${bus.availableSeats} seats available',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isFull ? Colors.grey : (isLowSeat ? AppColors.lowSeat : AppColors.availableSeat),
                  ),
                ),
                ElevatedButton(
                  onPressed: isFull
                      ? null
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SelectSeatScreen(bus: bus)),
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Book Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationColumn(String city, String label) {
    return Column(
      crossAxisAlignment: city == bus.arrival ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(city, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
      ],
    );
  }
}