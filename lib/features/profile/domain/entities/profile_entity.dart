import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String? imageUrl;

  const ProfileEntity({this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}