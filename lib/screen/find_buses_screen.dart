import 'package:booking_app/screen/select_seat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FindBusesScreen extends StatelessWidget {
  const FindBusesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: const Text('Phnom Penh to Siem Reap'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('buses').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No buses found'));
          }

          final buses = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: buses.length,
            itemBuilder: (context, index) {
              final bus = buses[index];
              final seatGridRaw = bus['seatGrid'] as List<dynamic>;
              // Parse seatGrid from Firestore to List<List<int>>
              final seatGrid = seatGridRaw
                  .map((row) => (row as List<dynamic>).map((e) => e as int).toList())
                  .toList();

              return BusResultCard(
                operator: bus['operator'],
                busType: bus['busType'],
                departure: bus['departure'],
                arrival: bus['arrival'],
                duration: bus['duration'],
                rating: bus['rating'],
                price: bus['price'],
                seatGrid: seatGrid,
              );
            },
          );
        },
      ),
    );
  }
}

class BusResultCard extends StatelessWidget {
  final String operator;
  final String busType;
  final String departure;
  final String arrival;
  final String duration;
  final double rating;
  final int price;
  final List<List<int>> seatGrid;

  const BusResultCard({
    super.key,
    required this.operator,
    required this.busType,
    required this.departure,
    required this.arrival,
    required this.duration,
    required this.rating,
    required this.price,
    required this.seatGrid,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        title: Text('$operator ($busType)'),
        subtitle: Text('$departure → $arrival | $duration'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('\$$price', style: const TextStyle(fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectSeatScreen(
                      operator: operator,
                      busType: busType,
                      price: price,
                      seatGrid: seatGrid,
                    ),
                  ),
                );
              },
              child: const Text('Select Seat'),
            ),
          ],
        ),
      ),
    );
  }
}
