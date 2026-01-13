import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? photoUrl;
  final String authProvider; // 'email', 'google', 'phone'
  final DateTime createdAt;

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.photoUrl,
    required this.authProvider,
    required this.createdAt,
  });

  // Create from Firebase Auth User
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

  // Create from Firestore document
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
    );
  }

  // Create from Map (needed for provider)
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] ?? '',
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      photoUrl: data['photoUrl'],
      authProvider: data['authProvider'] ?? 'email',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'authProvider': authProvider,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Convert to Map (useful for debugging and state management)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'authProvider': authProvider,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Copy with method for updates
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? authProvider,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      authProvider: authProvider ?? this.authProvider,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, authProvider: $authProvider)';
  }
}
