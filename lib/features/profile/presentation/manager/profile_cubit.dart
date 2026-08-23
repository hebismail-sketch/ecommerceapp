import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/save_profile_image.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfile getProfileUseCase;
  final SaveProfileImage saveProfileImageUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.saveProfileImageUseCase,
  }) : super(const ProfileInitial());

  Future<void> loadProfile(String userId) async {
    emit(const ProfileLoading());
    try {
      final profile = await getProfileUseCase.call(userId);
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> saveImage({
    required String userId,
    required File? selectedImage,
    required String? currentImageUrl,
  }) async {
    emit(const ProfileSaving());
    try {
      final profile = await saveProfileImageUseCase.call(
        userId: userId,
        selectedImage: selectedImage,
        currentImageUrl: currentImageUrl,
      );
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
}