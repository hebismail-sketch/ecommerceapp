import 'package:equatable/equatable.dart';

class ConversationEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final String lastSenderId;
  final int unreadForUser;
  final int unreadForAdmin;
  final String status;

  const ConversationEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.lastSenderId,
    required this.unreadForUser,
    required this.unreadForAdmin,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userEmail,
        lastMessage,
        lastMessageAt,
        lastSenderId,
        unreadForUser,
        unreadForAdmin,
        status,
      ];
}