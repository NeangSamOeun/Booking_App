import 'package:cloud_firestore/cloud_firestore.dart';

class TicketModel {
  final String id;
  final String userId;
  final String busId;
  final String route;
  final List<String> seats;
  final int totalPrice;
  final String status;
  final String pnr;
  final DateTime createdAt;

  TicketModel({
    required this.id,
    required this.userId,
    required this.busId,
    required this.route,
    required this.seats,
    required this.totalPrice,
    required this.status,
    required this.pnr,
    required this.createdAt,
  });

  factory TicketModel.fromMap(Map<String, dynamic> data, String id) {
    return TicketModel(
      id: id,
      userId: data['userId'] ?? '',
      busId: data['busId'] ?? '',
      route: data['route'] ?? '',
      seats: List<String>.from(data['seats'] ?? []),
      totalPrice: (data['totalPrice'] ?? 0) as int,
      status: data['status'] ?? 'Upcoming',
      pnr: data['pnr'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'busId': busId,
      'route': route,
      'seats': seats,
      'totalPrice': totalPrice,
      'status': status,
      'pnr': pnr,
      'createdAt': createdAt,
    };
  }
}
