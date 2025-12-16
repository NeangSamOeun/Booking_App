import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bus_model.dart';

/// ===== COLORS (Real project standard) =====
const Color kPrimaryRed = Color(0xFFE53935);
const Color kSeatAvailable = Color(0xFF9E9E9E);
const Color kSeatBooked = Color(0xFFE53935);
const Color kSeatSelected = Color(0xFF43A047);

class SelectSeatScreen extends StatefulWidget {
  final BusModel bus;

  const SelectSeatScreen({super.key, required this.bus});

  @override
  State<SelectSeatScreen> createState() => _SelectSeatScreenState();
}

class _SelectSeatScreenState extends State<SelectSeatScreen> {
  late List<List<int>> seatGrid;
  final List<String> selectedSeats = [];

  @override
  void initState() {
    super.initState();
    seatGrid = widget.bus.seatGrid.map((row) => [...row]).toList();
  }

  /// ===== Seat Toggle =====
  void toggleSeat(int row, int col) {
    if (seatGrid[row][col] == 1) return;

    setState(() {
      final seatLabel = '${row + 1}${String.fromCharCode(65 + col)}';

      if (seatGrid[row][col] == 0) {
        seatGrid[row][col] = 2;
        selectedSeats.add(seatLabel);
      } else {
        seatGrid[row][col] = 0;
        selectedSeats.remove(seatLabel);
      }
    });
  }

  /// ===== Seat Icon =====
  Icon seatIcon(int value) {
    switch (value) {
      case 0:
        return const Icon(Icons.event_seat_outlined,
            color: kSeatAvailable, size: 34);
      case 1:
        return const Icon(Icons.event_seat,
            color: kSeatBooked, size: 34);
      case 2:
        return const Icon(Icons.event_seat,
            color: kSeatSelected, size: 34);
      default:
        return const Icon(Icons.event_seat_outlined);
    }
  }

  /// ===== Confirm Booking =====
  Future<void> confirmBooking() async {
    if (selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one seat')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Text(
          'Seats: ${selectedSeats.join(', ')}\n'
          'Total: \$${(selectedSeats.length * widget.bus.price).toStringAsFixed(2)}',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style:
                ElevatedButton.styleFrom(backgroundColor: kPrimaryRed),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final bookingRef =
        FirebaseFirestore.instance.collection('bookings').doc();

    await bookingRef.set({
      'userId': user.uid,
      'busId': widget.bus.id,
      'route': '${widget.bus.departure} → ${widget.bus.arrival}',
      'seats': selectedSeats,
      'totalPrice': selectedSeats.length * widget.bus.price,
      'status': 'Upcoming',
      'pnr': bookingRef.id.substring(0, 6).toUpperCase(),
      'createdAt': Timestamp.now(),
    });

    /// Save updated seat grid
    final flatSeatGrid = seatGrid.expand((row) => row).toList();

    await FirebaseFirestore.instance
        .collection('buses')
        .doc(widget.bus.id)
        .update({'seatGrid': flatSeatGrid});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking confirmed!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = selectedSeats.length * widget.bus.price;

    return Scaffold(
      backgroundColor: Colors.grey[100],

      /// ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: kPrimaryRed,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Select Seat',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),

      /// ===== BODY =====
      body: Column(
        children: [
          const SizedBox(height: 12),

          /// ===== LEGEND =====
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6)
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _Legend(color: kSeatAvailable, label: 'Available'),
                _Legend(color: kSeatBooked, label: 'Booked'),
                _Legend(color: kSeatSelected, label: 'Selected'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// ===== DRIVER =====
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Row(
              children: const [
                Icon(Icons.person),
                SizedBox(width: 8),
                Text('Driver'),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// ===== SEAT GRID =====
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: seatGrid.length * seatGrid[0].length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
              ),
              itemBuilder: (context, index) {
                final row = index ~/ seatGrid[0].length;
                final col = index % seatGrid[0].length;

                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => toggleSeat(row, col),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      seatIcon(seatGrid[row][col]),
                      const SizedBox(height: 4),
                      Text(
                        '${row + 1}${String.fromCharCode(65 + col)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          /// ===== BOTTOM BAR =====
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10)
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedSeats.isEmpty
                            ? 'No seat selected'
                            : 'Seats: ${selectedSeats.join(', ')}',
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Total: \$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      selectedSeats.isEmpty ? null : confirmBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryRed,
                    disabledBackgroundColor: Colors.grey[400],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Book Now',
                    style:
                        TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ===== LEGEND WIDGET =====
class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.event_seat, color: color, size: 16),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
