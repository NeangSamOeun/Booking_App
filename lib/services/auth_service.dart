import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---------------- LOGIN ----------------
  Future<AppUser?> login(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final user = result.user;
    if (user == null) return null;

    return await getCurrentUser();
  }

  // ---------------- REGISTER ----------------
  Future<AppUser?> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String gender,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final user = result.user;
    if (user == null) return null;

    final newUser = AppUser(
      uid: user.uid,
      email: user.email ?? '',
      firstName: firstName,
      lastName: lastName,
      gender: gender,
    );

    await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

    return newUser;
  }

  // ---------------- LOGOUT ----------------
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ---------------- CURRENT USER ----------------
  Future<AppUser?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    return AppUser.fromFirebase(
      uid: user.uid,
      email: user.email ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      gender: data['gender'] ?? '',
    );
  }

  // ---------------- UPDATE PROFILE ----------------
  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String gender,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user logged in");

    await _firestore.collection('users').doc(user.uid).update({
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
    });
  }

  // ---------------- GET NAMES ----------------
  Future<String?> getFullName() async {
    final user = await getCurrentUser();
    if (user == null) return null;
    return '${user.firstName} ${user.lastName}';
  }

  Future<String?> getLastName() async {
    final user = await getCurrentUser();
    if (user == null) return null;
    return user.lastName;
  }

  // ---------------- DELETE USER ----------------
  Future<void> deleteUser() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user logged in");

    await _firestore.collection('users').doc(user.uid).delete();
    await user.delete();
  }
}
