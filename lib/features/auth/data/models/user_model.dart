import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? photoUrl;
  final String authProvider;
  final DateTime createdAt;
  // ── Profile completion fields ──
  final String? gender;
  final String? houseName;
  final String? address;
  final double? latitude;
  final double? longitude;

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.photoUrl,
    required this.authProvider,
    required this.createdAt,
    this.gender,
    this.houseName,
    this.address,
    this.latitude,
    this.longitude,
  });

  factory UserModel.fromFirebaseUser({
    required String uid,
    String? displayName,
    String? email,
    String? phoneNumber,
    String? photoURL,
    required String provider,
  }) {
    return UserModel(
      id: uid,
      name: displayName,
      email: email,
      phone: phoneNumber,
      photoUrl: photoURL,
      authProvider: provider,
      createdAt: DateTime.now(),
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      photoUrl: data['photoUrl'],
      authProvider: data['authProvider'] ?? 'email',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      gender: data['gender'],
      houseName: data['houseName'],
      address: data['address'],
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'authProvider': authProvider,
      'createdAt': FieldValue.serverTimestamp(),
      'gender': gender,
      'houseName': houseName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? authProvider,
    DateTime? createdAt,
    String? gender,
    String? houseName,
    String? address,
    double? latitude,
    double? longitude,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      authProvider: authProvider ?? this.authProvider,
      createdAt: createdAt ?? this.createdAt,
      gender: gender ?? this.gender,
      houseName: houseName ?? this.houseName,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  String toString() =>
      'UserModel(id: $id, name: $name, email: $email, phone: $phone, authProvider: $authProvider)';
}
