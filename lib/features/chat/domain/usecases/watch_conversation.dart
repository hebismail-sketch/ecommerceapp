import '../entities/conversation_entity.dart';
import '../repositories/chat_repository.dart';

class WatchConversation {
  final ChatRepository repository;

  WatchConversation(this.repository);

  Stream<ConversationEntity?> call(String userId) {
    return repository.watchConversation(userId);
  }
}