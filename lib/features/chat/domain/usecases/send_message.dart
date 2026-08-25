import '../entities/chat_message_entity.dart';
import '../entities/conversation_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<void> call({
    required String conversationId,
    required ChatMessageEntity message,
    required ConversationEntity conversation,
  }) {
    return repository.sendMessage(
      conversationId: conversationId,
      message: message,
      conversation: conversation,
    );
  }
}