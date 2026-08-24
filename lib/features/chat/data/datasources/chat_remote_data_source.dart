import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';

abstract class ChatRemoteDataSource {
  Stream<ConversationModel?> watchConversation(String userId);

  Stream<List<ConversationModel>> watchAdminConversations();

  Stream<List<ChatMessageModel>> watchMessages(String conversationId);

  Future<void> sendMessage({
    required String conversationId,
    required ChatMessageModel message,
    required ConversationModel conversation,
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