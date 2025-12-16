import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bus_model.dart';
import 'select_seat_screen.dart';
import 'addBusScreen.dart';

/// ================= THEME COLORS =================
class AppColors {
  static const primary = Color(0xFFE53935);
  static const background = Color(0xFFF5F5F5);
  static const textDark = Color(0xFF212121);
  static const textGrey = Color(0xFF757575);
  static const lowSeat = Color(0xFFD32F2F);
  static const availableSeat = Color(0xFF388E3C);
}

/// ================= FIND BUSES SCREEN =================
class FindBusesScreen extends StatelessWidget {
  const FindBusesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Find Your Bus',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      /// ================= BODY =================
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('buses')
            .orderBy('startDate') // order by start date
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No buses available',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final buses = snapshot.data!.docs.map((doc) {
            return BusModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: buses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final bus = buses[index];
              return _BusCard(bus: bus);
            },
          );
        },
      ),

      /// ================= ADMIN BUTTON =================
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: AppColors.primary,
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (_) => const AddBusScreen()),
      //     );
      //   },
      //   icon: const Icon(Icons.add, color: Colors.white),
      //   label: const Text(
      //     'Add Bus',
      //     style: TextStyle(color: Colors.white),
      //   ),
      // ),
    );
  }
}

/// ================= BUS CARD =================
class _BusCard extends StatelessWidget {
  final BusModel bus;

  const _BusCard({required this.bus});

  @override
  Widget build(BuildContext context) {
    final bool isLowSeat = bus.availableSeats <= 5;
    final startDateStr =
        "${bus.startDate.day.toString().padLeft(2, '0')}-${bus.startDate.month.toString().padLeft(2, '0')}-${bus.startDate.year}";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------- OPERATOR & PRICE ----------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '${bus.operator} • ${bus.busType}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                Text(
                  '\$${bus.price}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// ---------- ROUTE & DURATION ----------
            Row(
              children: [
                _RoutePoint(title: bus.departure),
                const Icon(Icons.arrow_forward, size: 16),
                _RoutePoint(title: bus.arrival),
                const SizedBox(width: 8),
                Text(
                  '• ${bus.duration}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// ---------- START DATE ----------
            Row(
              children: [
                const Icon(Icons.date_range, size: 16, color: AppColors.textGrey),
                const SizedBox(width: 4),
                Text(
                  'Start: $startDateStr',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),

            /// ---------- ACTION ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${bus.availableSeats} seats left',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isLowSeat ? AppColors.lowSeat : AppColors.availableSeat,
                  ),
                ),
                ElevatedButton(
                  onPressed: bus.availableSeats == 0
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SelectSeatScreen(bus: bus),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: Colors.grey[400],
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    bus.availableSeats == 0 ? 'Full' : 'Select Seat',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= ROUTE POINT =================
class _RoutePoint extends StatelessWidget {
  final String title;

  const _RoutePoint({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }
}

