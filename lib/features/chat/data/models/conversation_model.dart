import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  const ConversationModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.userEmail,
    required super.lastMessage,
    required super.lastMessageAt,
    required super.lastSenderId,
    required super.unreadForUser,
    required super.unreadForAdmin,
    required super.status,
  });

  factory ConversationModel.fromJson(
    String id,
    Map<String, dynamic> data,
  ) {
    final timestamp = data['lastMessageAt'];

    return ConversationModel(
      id: id,
      userId: data['userId'] as String? ?? '',
      userName: data['userName'] as String? ?? '',
      userEmail: data['userEmail'] as String? ?? '',
      lastMessage: data['lastMessage'] as String? ?? '',
      lastMessageAt: timestamp is Timestamp ? timestamp.toDate() : null,
      lastSenderId: data['lastSenderId'] as String? ?? '',
      unreadForUser: (data['unreadForUser'] as num?)?.toInt() ?? 0,
      unreadForAdmin: (data['unreadForAdmin'] as num?)?.toInt() ?? 0,
      status: data['status'] as String? ?? 'open',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt == null
          ? null
          : Timestamp.fromDate(lastMessageAt!),
      'lastSenderId': lastSenderId,
      'unreadForUser': unreadForUser,
      'unreadForAdmin': unreadForAdmin,
      'status': status,
    };
  }
}