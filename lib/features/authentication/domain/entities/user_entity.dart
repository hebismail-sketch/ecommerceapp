import 'package:equatable/equatable.dart';


class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String username;
  final String role;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.username,
    required this.role,
  });

  @override
  List<Object> get props => [uid, email, username, role];
}

