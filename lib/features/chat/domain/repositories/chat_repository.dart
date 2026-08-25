import '../entities/chat_message_entity.dart';
import '../entities/conversation_entity.dart';

abstract class ChatRepository {
  Stream<ConversationEntity?> watchConversation(String userId);

  Stream<List<ConversationEntity>> watchAdminConversations();

  Stream<List<ChatMessageEntity>> watchMessages(String conversationId);

  Future<void> sendMessage({
    required String conversationId,
    required ChatMessageEntity message,
    required ConversationEntity conversation,
  });

  Future<void> markMessagesAsRead({
    required String conversationId,
    required String readerRole,
  });

  Future<void> updateConversationStatus({
    required String conversationId,
    required String status,
  });
}