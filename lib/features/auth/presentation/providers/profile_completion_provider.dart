import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whirl_wash/features/auth/data/repositories/profile_repository.dart';

// =====================================================================
// STATE
// =====================================================================

class ProfileCompletionState {
  final bool isLoading;
  final String? error;
  final String? selectedGender;
  final File? profileImage;

  ProfileCompletionState({
    this.isLoading = false,
    this.error,
    this.selectedGender,
    this.profileImage,
  });

  ProfileCompletionState copyWith({
    bool? isLoading,
    String? error,
    String? selectedGender,
    File? profileImage,
  }) {
    return ProfileCompletionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedGender: selectedGender ?? this.selectedGender,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

// =====================================================================
// NOTIFIER
// =====================================================================

class ProfileCompletionNotifier extends Notifier<ProfileCompletionState> {
  final _repo = ProfileRepository();

  @override
  ProfileCompletionState build() => ProfileCompletionState();

  void setGender(String gender) =>
      state = state.copyWith(selectedGender: gender);

  void setProfileImage(File? image) =>
      state = state.copyWith(profileImage: image);

  void clearError() => state = state.copyWith(error: null);

  Future<bool> completeProfile({
    required String name,
    required String phone,
    required String? gender,
    required String houseName,
    required String address,
    required double? latitude,
    required double? longitude,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.saveProfile(
        name: name,
        phone: phone,
        gender: gender,
        houseName: houseName,
        address: address,
        latitude: latitude,
        longitude: longitude,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error: ${e.toString()}');
      return false;
    }
  }
}

// =====================================================================
// PROVIDER
// =====================================================================

final profileCompletionProvider =
    NotifierProvider<ProfileCompletionNotifier, ProfileCompletionState>(
      ProfileCompletionNotifier.new,
    );
