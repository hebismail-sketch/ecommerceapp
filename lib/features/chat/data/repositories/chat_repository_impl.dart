import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Stream<ConversationEntity?> watchConversation(String userId) {
    return remoteDataSource.watchConversation(userId);
  }

  @override
  Stream<List<ConversationEntity>> watchAdminConversations() {
    return remoteDataSource.watchAdminConversations();
  }

  @override
  Stream<List<ChatMessageEntity>> watchMessages(String conversationId) {
    return remoteDataSource.watchMessages(conversationId);
  }

  @override
  Future<void> sendMessage({
    required String conversationId,
    required ChatMessageEntity message,
    required ConversationEntity conversation,
  }) {
    return remoteDataSource.sendMessage(
      conversationId: conversationId,
      message: ChatMessageModel(
        id: message.id,
        conversationId: message.conversationId,
        senderId: message.senderId,
        senderName: message.senderName,
        senderRole: message.senderRole,
        text: message.text,
        type: message.type,
        createdAt: message.createdAt,
        isRead: message.isRead,
        productId: message.productId,
        productNameAr: message.productNameAr,
        productNameEn: message.productNameEn,
        productImage: message.productImage,
        productPrice: message.productPrice,
      ),
      conversation: ConversationModel(
        id: conversation.id,
        userId: conversation.userId,
        userName: conversation.userName,
        userEmail: conversation.userEmail,
        lastMessage: conversation.lastMessage,
        lastMessageAt: conversation.lastMessageAt,
        lastSenderId: conversation.lastSenderId,
        unreadForUser: conversation.unreadForUser,
        unreadForAdmin: conversation.unreadForAdmin,
        status: conversation.status,
      ),
    );
  }

  @override
  Future<void> markMessagesAsRead({
    required String conversationId,
    required String readerRole,
  }) {
    return remoteDataSource.markMessagesAsRead(
      conversationId: conversationId,
      readerRole: readerRole,
    );
  }

  @override
  Future<void> updateConversationStatus({
    required String conversationId,
    required String status,
  }) {
    return remoteDataSource.updateConversationStatus(
      conversationId: conversationId,
      status: status,
    );
  }
}