import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class WatchMessages {
  final ChatRepository repository;

  WatchMessages(this.repository);

  Stream<List<ChatMessageEntity>> call(String conversationId) {
    return repository.watchMessages(conversationId);
  }
}