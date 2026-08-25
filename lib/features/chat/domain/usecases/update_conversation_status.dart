import '../repositories/chat_repository.dart';

class UpdateConversationStatus {
  final ChatRepository repository;

  UpdateConversationStatus(this.repository);

  Future<void> call({
    required String conversationId,
    required String status,
  }) {
    return repository.updateConversationStatus(
      conversationId: conversationId,
      status: status,
    );
  }
}