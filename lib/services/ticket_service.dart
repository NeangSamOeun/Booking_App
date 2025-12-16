import 'package:booking_app/models/Ttcket_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TicketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---------------- GET TICKETS FOR CURRENT USER ----------------
  Stream<List<TicketModel>> getTickets({required String status}) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      // Return empty stream if not logged in
      return Stream.value([]);
    }

    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: currentUserId)
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true) // Use 'createdAt' if that's your timestamp field
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return TicketModel.fromMap(data, doc.id);
      }).toList();
    });
  }

  // ---------------- ADD TICKET ----------------
  Future<void> addTicket(TicketModel ticket) async {
    await _firestore.collection('bookings').add(ticket.toMap());
  }

  // ---------------- CANCEL TICKET ----------------
  Future<void> cancelTicket(String ticketId) async {
    await _firestore
        .collection('bookings')
        .doc(ticketId)
        .update({'status': 'Cancelled'});
  }
}
