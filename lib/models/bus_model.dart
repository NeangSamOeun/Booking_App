// class BusModel {
//   final String id;
//   final String operator;
//   final String busType;
//   final String departure;
//   final String arrival;
//   final String duration;
//   final double rating;
//   final int price;

//   BusModel({
//     required this.id,
//     required this.operator,
//     required this.busType,
//     required this.departure,
//     required this.arrival,
//     required this.duration,
//     required this.rating,
//     required this.price,
//   });

//   factory BusModel.fromFirestore(Map<String, dynamic> data, String id) {
//     return BusModel(
//       id: id,
//       operator: data['operator'],
//       busType: data['busType'],
//       departure: data['departure'],
//       arrival: data['arrival'],
//       duration: data['duration'],
//       rating: (data['rating'] as num).toDouble(),
//       price: data['price'],
//     );
//   }
// }

// class BusModel {
//   final String id;
//   final String operator;
//   final String busType;
//   final String departure;
//   final String arrival;
//   final String duration;
//   final double rating;
//   final int price;
//   final List<List<int>> seatGrid;

//   BusModel({
//     required this.id,
//     required this.operator,
//     required this.busType,
//     required this.departure,
//     required this.arrival,
//     required this.duration,
//     required this.rating,
//     required this.price,
//     required this.seatGrid,
//   });

//   factory BusModel.fromFirestore(Map<String, dynamic> data, String id) {
//   final flatSeatsDynamic = List.from(data['seatGrid'] ?? []);
//   final flatSeats = flatSeatsDynamic.map((e) => (e as num).toInt()).toList();

//   final rows = data['rows'] ?? 4;
//   final cols = data['cols'] ?? 4;

//   List<List<int>> grid = [];
//   for (int r = 0; r < rows; r++) {
//     grid.add(flatSeats.sublist((r * cols as int), ((r + 1) * cols) as int?));
//   }

//   return BusModel(
//     id: id,
//     operator: data['operator'] ?? '',
//     busType: data['busType'] ?? '',
//     departure: data['departure'] ?? '',
//     arrival: data['arrival'] ?? '',
//     duration: data['duration'] ?? '',
//     rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
//     price: (data['price'] as num?)?.toInt() ?? 0,
//     seatGrid: grid,
//   );
// }

//   int get availableSeats =>
//       seatGrid.expand((row) => row).where((seat) => seat == 0).length;

// }

import 'package:cloud_firestore/cloud_firestore.dart';

class BusModel {
  final String id;
  final String operator;
  final String busType;
  final String departure; // From city
  final String arrival;   // To city
  final String duration;
  final double rating;
  final int price;
  final List<List<int>> seatGrid;
  final int rows;
  final int cols;
  final DateTime startDate; // NEW

  BusModel({
    required this.id,
    required this.operator,
    required this.busType,
    required this.departure,
    required this.arrival,
    required this.duration,
    required this.rating,
    required this.price,
    required this.seatGrid,
    this.rows = 4,
    this.cols = 4,
    required this.startDate, // NEW
  });

  factory BusModel.fromFirestore(Map<String, dynamic> data, String id) {
    final flatSeatsDynamic = List.from(data['seatGrid'] ?? []);
    final flatSeats = flatSeatsDynamic.map((e) => (e as num).toInt()).toList();

    final rows = data['rows'] ?? 4;
    final cols = data['cols'] ?? 4;

    List<List<int>> grid = [];
    for (int r = 0; r < rows; r++) {
      num start = r * cols;
      num end = start + cols;
      if (start >= flatSeats.length) break;
      grid.add(flatSeats.sublist(start as int, (end > flatSeats.length ? flatSeats.length : end) as int?));
    }

    final Timestamp? startTimestamp = data['startDate'];
    final DateTime startDate = startTimestamp?.toDate() ?? DateTime.now();

    return BusModel(
      id: id,
      operator: data['operator'] ?? '',
      busType: data['busType'] ?? '',
      departure: data['from'] ?? '',
      arrival: data['to'] ?? '',
      duration: data['duration'] ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      price: (data['price'] as num?)?.toInt() ?? 0,
      seatGrid: grid,
      rows: rows,
      cols: cols,
      startDate: startDate, // NEW
    );
  }

  int get availableSeats => seatGrid.expand((row) => row).where((seat) => seat == 0).length;

  List<int> flattenSeatGrid() => seatGrid.expand((row) => row).toList();
}
