// ----------------------------------------------------------------------------------
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Initialize Google Sign-In
  Future<void> initializeGoogleSignIn() async {
    try {
      await GoogleSignIn.instance.initialize();
    } catch (e) {
      print('Google Sign-In initialization error: $e');
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);

      if (userCredential.user != null) {
        final user = userCredential.user!;

        final userModel = UserModel.fromFirebaseUser(
          uid: user.uid,
          displayName: name,
          email: email,
          provider: 'email',
        );

        await _firestore.collection('users').doc(user.uid).set({
          ...userModel.toFirestore(),
          'profileComplete': false,
        });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final user = userCredential.user!;

        final userModel = UserModel.fromFirebaseUser(
          uid: user.uid,
          displayName: user.displayName,
          email: user.email,
          photoURL: user.photoURL,
          provider: 'google',
        );

        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            ...userModel.toFirestore(),
            'profileComplete': true,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        } else {
          await _firestore.collection('users').doc(user.uid).set({
            ...userModel.toFirestore(),
            'profileComplete': true,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred during Google sign in: $e';
    }
  }

  // Send OTP
  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(_handleAuthException(e));
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      onError('Failed to send OTP: $e');
    }
  }

  // Verify OTP
  Future<UserCredential?> verifyOTP({
    required String verificationId,
    required String otp,
    String? name,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final user = userCredential.user!;
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final existingUser = UserModel.fromFirestore(userDoc);

          final hasPhone =
              existingUser.phone != null && existingUser.phone!.isNotEmpty;
          final hasName =
              existingUser.name != null && existingUser.name!.isNotEmpty;

          final userData = userDoc.data() as Map<String, dynamic>;
          final hasGender =
              userData['gender'] != null &&
              userData['gender'].toString().isNotEmpty;
          final alreadyComplete = userData['profileComplete'] == true;

          if (hasPhone && hasName && hasGender && !alreadyComplete) {
            await _firestore.collection('users').doc(user.uid).update({
              'profileComplete': true,
              'updatedAt': FieldValue.serverTimestamp(),
            });
          }
        } else {
          final userModel = UserModel.fromFirebaseUser(
            uid: user.uid,
            displayName: name ?? user.displayName,
            phoneNumber: user.phoneNumber,
            provider: 'phone',
          );

          await _firestore.collection('users').doc(user.uid).set({
            ...userModel.toFirestore(),
            'profileComplete': false,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred during OTP verification';
    }
  }

  // ============ FORGOT PASSWORD ============

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.disconnect();
    } catch (e) {
      print('Google sign out error: $e');
    }
    await _auth.signOut();
  }

  // Get user data from Firestore
  Future<UserModel?> getUserFromFirestore(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error fetching user from Firestore: $e');
      return null;
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign in method is not enabled.';
      case 'invalid-verification-code':
        return 'The verification code is invalid.';
      case 'invalid-verification-id':
        return 'The verification ID is invalid.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}
