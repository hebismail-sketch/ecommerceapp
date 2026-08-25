import '../entities/conversation_entity.dart';
import '../repositories/chat_repository.dart';

class WatchAdminConversations {
  final ChatRepository repository;

  WatchAdminConversations(this.repository);

  Stream<List<ConversationEntity>> call() {
    return repository.watchAdminConversations();
  }
}