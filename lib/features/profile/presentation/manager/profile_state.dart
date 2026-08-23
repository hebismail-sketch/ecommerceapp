part of 'profile_cubit.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileSaving extends ProfileState {
  const ProfileSaving();
}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;

  const ProfileLoaded(this.profile);
}

class ProfileFailure extends ProfileState {
  final String message;

  const ProfileFailure(this.message);
}