import '../repositories/chat_repository.dart';

class MarkMessagesAsRead {
  final ChatRepository repository;

  MarkMessagesAsRead(this.repository);

  Future<void> call({
    required String conversationId,
    required String readerRole,
  }) {
    return repository.markMessagesAsRead(
      conversationId: conversationId,
      readerRole: readerRole,
    );
  }
}