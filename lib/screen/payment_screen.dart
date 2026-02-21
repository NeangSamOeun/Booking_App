import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../models/bus_model.dart';

// --- MODERN THEME COLORS ---
const Color kPrimaryRed = Color(0xFFD32F2F);
const Color kBgColor = Color(0xFFF4F7F6);
const Color kCardColor = Colors.white;

class PaymentScreen extends StatefulWidget {
  final BusModel bus;
  final List<String> selectedSeats;

  const PaymentScreen({super.key, required this.bus, required this.selectedSeats});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  String selectedMethod = "Credit Card"; // Tracks user choice

  @override
  Widget build(BuildContext context) {
    final double total = (widget.selectedSeats.length * widget.bus.price) as double;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryRed,
        centerTitle: true,
        title: const Text('Review & Pay', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. JOURNEY SUMMARY CARD
            _buildJourneyCard(),
            const SizedBox(height: 24),

            const Text("Select Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // 2. PAYMENT METHODS
            _paymentTile("Credit Card", Icons.credit_card, "Visa, Mastercard, JCB"),
            _paymentTile("Digital Wallet", Icons.wallet_outlined, "ABA, Wing, or Wallet"),
            _paymentTile("Apple Pay", Icons.apple, "Fast & Secure"),

            const SizedBox(height: 24),
            
            // 3. FARE BREAKDOWN
            _buildFareDetail(total),
          ],
        ),
      ),
      bottomNavigationBar: _buildPayButton(total),
    );
  }

  Widget _buildJourneyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _cityColumn(widget.bus.departure, "Departure"),
              const Icon(Icons.directions_bus, color: kPrimaryRed, size: 24),
              _cityColumn(widget.bus.arrival, "Arrival"),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${widget.selectedSeats.length} Seats", style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.selectedSeats.join(', '), style: const TextStyle(color: kPrimaryRed, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cityColumn(String city, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        Text(city, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _paymentTile(String id, IconData icon, String subtitle) {
    bool isSelected = selectedMethod == id;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? kPrimaryRed : Colors.transparent, width: 2),
          boxShadow: [if (!isSelected) BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: kBgColor, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: isSelected ? kPrimaryRed : Colors.black54),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle, color: kPrimaryRed),
          ],
        ),
      ),
    );
  }

  Widget _buildFareDetail(double total) {
    return Column(
      children: [
        _rowDetail("Base Fare", "\$${widget.bus.price}"),
        _rowDetail("Booking Fee", "Free"),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Total Payable", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("\$${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kPrimaryRed)),
          ],
        ),
      ],
    );
  }

  Widget _rowDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPayButton(double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () => _showConfirmPayment(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryRed,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            shadowColor: kPrimaryRed.withOpacity(0.3),
          ),
          child: Text('Pay \$${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // --- LOGIC FUNCTIONS (KEEPING YOUR DATABASE LOGIC) ---
  void _showConfirmPayment(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Confirm Transaction", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text("Confirm booking for ${widget.selectedSeats.length} seats?"),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel"))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: kPrimaryRed),
                  onPressed: () { Navigator.pop(context); _processPayment(context); },
                  child: const Text("Confirm", style: TextStyle(color: Colors.white)),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }

  // [Include your _processPayment and _showSuccessDialog functions here...]
  Future<void> _processPayment(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: kPrimaryRed)),
    );

    try {
      // Capture data before transaction to ensure it's available for the dialog
      final String routeName = "${widget.bus.departure} → ${widget.bus.arrival}";
      final List<String> bookedSeats = List.from(widget.selectedSeats);
      final double finalAmount = (bookedSeats.length * widget.bus.price) as double;

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final busRef = FirebaseFirestore.instance.collection('buses').doc(widget.bus.id);
        final snapshot = await transaction.get(busRef);
        
        if (!snapshot.exists) throw Exception("Bus not found");

        final List<int> flatGrid = List<int>.from(snapshot['seatGrid']);
        final int cols = widget.bus.seatGrid[0].length;

        List<List<int>> latestGrid = [];
        for (int i = 0; i < flatGrid.length; i += cols) {
          latestGrid.add(flatGrid.sublist(i, i + cols));
        }

        for (String seat in bookedSeats) {
          final int row = int.parse(seat.substring(0, seat.length - 1)) - 1;
          final int col = seat.codeUnitAt(seat.length - 1) - 65;

          if (latestGrid[row][col] == 1) throw Exception('Seat $seat is already booked.');
          latestGrid[row][col] = 1; 
        }

        transaction.update(busRef, {'seatGrid': latestGrid.expand((e) => e).toList()});

        final bookingRef = FirebaseFirestore.instance.collection('bookings').doc();
        transaction.set(bookingRef, {
          'userId': user.uid,
          'busId': widget.bus.id,
          'route': routeName,
          'seats': bookedSeats,
          'totalPrice': finalAmount,
          'status': 'Upcoming', // Make sure this matches your TicketsScreen filter
          'method': selectedMethod,
          'pnr': bookingRef.id.substring(0, 6).toUpperCase(),
          'dateTime': DateTime.now(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      });

      if (!mounted) return;
      Navigator.pop(context); // Close loading
      
      // Pass the data explicitly to the dialog
      _showSuccessDialog(context, routeName, bookedSeats, finalAmount);
      
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _showSuccessDialog(BuildContext context, String route, List<String> seats, double amount) {
    final String pnr = "PNR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _circularActionButton(Icons.share_outlined, () async {
                  // SHARE LOGIC
                  final image = await screenshotController.capture();
                  if (image != null) {
                    final directory = await getApplicationDocumentsDirectory();
                    final imagePath = await File('${directory.path}/ticket.png').create();
                    await imagePath.writeAsBytes(image);
                    await Share.shareXFiles([XFile(imagePath.path)], text: 'My Bus Ticket');
                  }
                }),
              ],
            ),
            const SizedBox(height: 15),
            Screenshot(
              controller: screenshotController,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(25),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 60),
                          SizedBox(height: 10),
                          Text("Booking Confirmed!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          _ticketRow("PNR NUMBER", pnr, isBold: true),
                          const SizedBox(height: 15),
                          _ticketRow("ROUTE", route),
                          const SizedBox(height: 15),
                          _ticketRow("SEATS", seats.join(", ")),
                          const SizedBox(height: 15),
                          _ticketRow("AMOUNT PAID", "\$${amount.toStringAsFixed(2)}", isBold: true),
                        ],
                      ),
                    ),
                    const _TicketDivider(),
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          const Icon(Icons.qr_code_2, size: 100, color: Colors.black87),
                          const SizedBox(height: 10),
                          const Text("Scan this at the counter", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 25),
                          ElevatedButton(
                            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryRed,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text("Go to My Bookings", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circularActionButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle, border: Border.all(color: Colors.white)),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _ticketRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
      ],
    );
  }
}

/// ===== DASHED TICKET DIVIDER WIDGET =====
class _TicketDivider extends StatelessWidget {
  const _TicketDivider();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: List.generate(20, (index) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(height: 1, color: Colors.grey[300]),
            ),
          )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(height: 20, width: 10, decoration: BoxDecoration(color: kBgColor, borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)))),
            Container(height: 20, width: 10, decoration: BoxDecoration(color: kBgColor, borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)))),
          ],
        ),
      ],
    );
  }
}