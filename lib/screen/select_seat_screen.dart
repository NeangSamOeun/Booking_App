import 'package:booking_app/screen/payment_screen.dart';
import 'package:flutter/material.dart';
import '../models/bus_model.dart';

/// ===== COLORS FROM IMAGE =====
const Color kPrimaryRed = Color(0xFFD32F2F);
const Color kSeatAvailable = Color(0xFFE0E0E0);
const Color kSeatBooked = Color(0xFFE53935);
const Color kSeatSelected = Color(0xFF4CAF50);

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
    // Copy grid from bus model
    seatGrid = widget.bus.seatGrid.map((row) => [...row]).toList();
  }

  void toggleSeat(int row, int col) {
    if (seatGrid[row][col] == 1) return; // Ignore booked seats

    setState(() {
      final label = '${row + 1}${String.fromCharCode(65 + col)}';
      if (seatGrid[row][col] == 0) {
        seatGrid[row][col] = 2;
        selectedSeats.add(label);
      } else {
        seatGrid[row][col] = 0;
        selectedSeats.remove(label);
      }
    });
  }

  /// ===== SEAT ICON WIDGET =====
  Widget seatIcon(int value) {
    Color iconColor;
    if (value == 1) iconColor = kSeatBooked;
    else if (value == 2) iconColor = kSeatSelected;
    else iconColor = kSeatAvailable;

    return Icon(
      Icons.chair_rounded, // Best matches the "Bus Seat" look in your image
      size: 44,
      color: iconColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = selectedSeats.length * widget.bus.price;

    return Scaffold(
      backgroundColor: kPrimaryRed,
      appBar: AppBar(
        backgroundColor: kPrimaryRed,
        elevation: 0,
        centerTitle: true,
        title: const Text('Select Your Seat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 10, 16, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // 1. TOP HEADER (DRIVER & ENTRY)
                  _buildDeskHeader(),
                  
                  // 2. FRONT DIVIDER
                  _buildFrontDivider(),

                  // 3. SEATING GRID WITH AISLE
                  Expanded(
                    child: _buildSeatGrid(),
                  ),
                ],
              ),
            ),
          ),

          // 4. BOTTOM ACTION BAR
          _buildBottomBar(total as double),
        ],
      ),
    );
  }

  Widget _buildDeskHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _headerIcon(Icons.tire_repair, "DRIVER"), // Steering wheel substitute
          const _LegendRow(),
          _headerIcon(Icons.door_front_door_outlined, "ENTRY"),
        ],
      ),
    );
  }

  Widget _headerIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey, size: 30),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildFrontDivider() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: kPrimaryRed,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text("FRONT", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        const Divider(indent: 20, endIndent: 20, thickness: 1),
      ],
    );
  }

  Widget _buildSeatGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // Set crossAxisCount to 5 to create an empty middle column for the AISLE
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, 
        mainAxisSpacing: 8,
        crossAxisSpacing: 2,
        childAspectRatio: 0.8,
      ),
      itemCount: seatGrid.length * 5, 
      itemBuilder: (context, index) {
        int row = index ~/ 5;
        int col = index % 5;

        // Create the Aisle (Middle Column)
        if (col == 2) return const SizedBox.shrink();

        // Adjust column index for data mapping because we added a fake middle column
        int dataCol = col > 2 ? col - 1 : col;
        int value = seatGrid[row][dataCol];

        return GestureDetector(
          onTap: () => toggleSeat(row, dataCol),
          child: Column(
            children: [
              seatIcon(value),
              Text(
                '${row + 1}${String.fromCharCode(65 + dataCol)}',
                style: const TextStyle(fontSize: 9, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(double total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${selectedSeats.length} Seat Selected', style: const TextStyle(color: Colors.grey)),
              Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kPrimaryRed)),
            ],
          ),
          ElevatedButton(
            onPressed: selectedSeats.isEmpty ? null : () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen(bus: widget.bus, selectedSeats: selectedSeats)));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryRed,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

/// ===== LEGEND SUB-WIDGET =====
class _LegendRow extends StatelessWidget {
  const _LegendRow();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _dot(kSeatAvailable, "Available"),
        const SizedBox(width: 10),
        _dot(kSeatBooked, "Booked"),
        const SizedBox(width: 10),
        _dot(kSeatSelected, "Selected"),
      ],
    );
  }

  Widget _dot(Color color, String text) {
    return Row(
      children: [
        Icon(Icons.chair_rounded, size: 18, color: color),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 10, color: Colors.black87)),
      ],
    );
  }
}