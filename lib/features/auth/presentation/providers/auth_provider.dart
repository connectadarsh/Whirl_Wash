// ---------------------------------------------------------------------------------------------
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:whirl_wash/core/router/app_router_gorouter.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Auth state provider - tracks current user
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// Current user data provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user != null) {
        return ref.read(authRepositoryProvider).getUserFromFirestore(user.uid);
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// Auth controller state
class AuthState {
  final bool isLoading;
  final String? error;
  final String? successMessage;
  final String? verificationId; // For phone auth

  AuthState({
    this.isLoading = false,
    this.error,
    this.successMessage,
    this.verificationId,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
    String? verificationId,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
      verificationId: verificationId ?? this.verificationId,
    );
  }
}

// Auth controller - Modern Notifier
class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState();
  }

  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  // ============ EMAIL/PASSWORD AUTH ============

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authRepository.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      );
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Account created successfully!',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authRepository.signInWithEmail(email: email, password: password);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Login successful!',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ============ GOOGLE AUTH ============

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authRepository.signInWithGoogle();

      if (user != null) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Signed in with Google!',
        );
      } else {
        // User cancelled
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ============ PHONE AUTH ============

  Future<void> sendOTP(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null);

    await _authRepository.sendOTP(
      phoneNumber: phoneNumber,
      onCodeSent: (verificationId) {
        state = state.copyWith(
          isLoading: false,
          verificationId: verificationId,
          successMessage: 'OTP sent successfully!',
        );
      },
      onError: (error) {
        state = state.copyWith(isLoading: false, error: error);
      },
    );
  }

  Future<void> verifyOTP({required String otp, String? name}) async {
    if (state.verificationId == null) {
      state = state.copyWith(
        error: 'Verification ID not found. Please request a new OTP.',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authRepository.verifyOTP(
        otp: otp,
        verificationId: state.verificationId!,
        name: name,
      );
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Phone verified successfully!',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ============ COMMON METHODS ============

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authRepository.signOut();
      state = AuthState(); // Reset state
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to sign out: ${e.toString()}',
      );
    }
  }

  // Clear error message
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Clear success message
  void clearSuccess() {
    state = state.copyWith(successMessage: null);
  }
}

// Auth controller provider - Modern NotifierProvider
final authControllerProvider = NotifierProvider<AuthController, AuthState>(() {
  return AuthController();
});
