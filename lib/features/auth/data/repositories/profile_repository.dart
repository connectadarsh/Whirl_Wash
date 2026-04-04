import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> saveProfile({
    required String name,
    required String phone,
    required String? gender,
    required String houseName,
    required String address,
    required double? latitude,
    required double? longitude,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw 'User not found';

    await user.updateDisplayName(name);

    await _db.collection('users').doc(user.uid).set({
      'name': name,
      'phone': phone,
      'gender': gender,
      'houseName': houseName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'profileComplete': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
