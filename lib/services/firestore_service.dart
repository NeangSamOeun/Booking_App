import 'package:booking_app/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bus_model.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Stream<List<BusModel>> getBuses() {
    return _db.collection('buses').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => BusModel.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> updateSeatGrid(String busId, List<List<int>> seatGrid) async {
    await _db.collection('buses').doc(busId).update({
      'seatGrid': seatGrid,
    });
  }

}
