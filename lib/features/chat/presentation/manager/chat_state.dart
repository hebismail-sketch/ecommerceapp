import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/conversation_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatLoaded extends ChatState {
  final ConversationEntity? conversation;
  final List<ConversationEntity> adminConversations;
  final List<ChatMessageEntity> messages;

  const ChatLoaded({
    this.conversation,
    this.adminConversations = const [],
    this.messages = const [],
  });

  @override
  List<Object?> get props => [
        conversation,
        adminConversations,
        messages,
      ];
}

class ChatFailure extends ChatState {
  final String message;

  const ChatFailure(this.message);

  @override
  List<Object?> get props => [message];
}