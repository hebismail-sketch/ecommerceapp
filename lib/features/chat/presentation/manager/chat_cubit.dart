import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/usecases/mark_messages_as_read.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/update_conversation_status.dart';
import '../../domain/usecases/watch_admin_conversations.dart';
import '../../domain/usecases/watch_conversation.dart';
import '../../domain/usecases/watch_messages.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final WatchConversation watchConversationUseCase;
  final WatchAdminConversations watchAdminConversationsUseCase;
  final WatchMessages watchMessagesUseCase;
  final SendMessage sendMessageUseCase;
  final MarkMessagesAsRead markMessagesAsReadUseCase;
  final UpdateConversationStatus updateConversationStatusUseCase;

  StreamSubscription<ConversationEntity?>? _conversationSubscription;
  StreamSubscription<List<ConversationEntity>>? _adminConversationsSubscription;
  StreamSubscription<List<ChatMessageEntity>>? _messagesSubscription;

  ChatCubit({
    required this.watchConversationUseCase,
    required this.watchAdminConversationsUseCase,
    required this.watchMessagesUseCase,
    required this.sendMessageUseCase,
    required this.markMessagesAsReadUseCase,
    required this.updateConversationStatusUseCase,
  }) : super(const ChatInitial());

  void watchConversation(String userId) {
    emit(const ChatLoading());
    _conversationSubscription?.cancel();
    _conversationSubscription = watchConversationUseCase(userId).listen(
      (conversation) {
        final currentState = state is ChatLoaded
            ? state as ChatLoaded
            : const ChatLoaded();
        emit(ChatLoaded(
            conversation: conversation,
            adminConversations: currentState.adminConversations,
            messages: currentState.messages,
        ));
      },
      onError: (error) => emit(ChatFailure(error.toString())),
    );
  }

  void watchAdminConversations() {
    emit(const ChatLoading());
    _adminConversationsSubscription?.cancel();
    _adminConversationsSubscription = watchAdminConversationsUseCase().listen(
      (conversations) {
        final currentState = state is ChatLoaded
            ? state as ChatLoaded
            : const ChatLoaded();
        emit(ChatLoaded(
            conversation: currentState.conversation,
            adminConversations: conversations,
            messages: currentState.messages,
        ));
      },
      onError: (error) => emit(ChatFailure(error.toString())),
    );
  }
  void watchMessages(String conversationId) {
    _messagesSubscription?.cancel();
    _messagesSubscription = watchMessagesUseCase(conversationId).listen(
      (messages) {
        final currentState = state is ChatLoaded
            ? state as ChatLoaded
            : const ChatLoaded();
        emit(ChatLoaded(
            conversation: currentState.conversation,
            adminConversations: currentState.adminConversations,
            messages: messages,
        ));
      },
      onError: (error) => emit(ChatFailure(error.toString())),
    );
  }

  Future<void> sendMessage({
    required String conversationId,
    required ChatMessageEntity message,
    required ConversationEntity conversation,
  }) async {
    try {
      await sendMessageUseCase(
        conversationId: conversationId,
        message: message,
        conversation: conversation,
      );
    } catch (error) {
      emit(ChatFailure(error.toString()));
    }
  }

  Future<void> markMessagesAsRead({
    required String conversationId,
    required String readerRole,
  }) async {
    try {
      await markMessagesAsReadUseCase(
        conversationId: conversationId,
        readerRole: readerRole,
      );
    } catch (error) {
      emit(ChatFailure(error.toString()));
    }
  }

  Future<void> updateConversationStatus({
    required String conversationId,
    required String status,
  }) async {
    try {
      await updateConversationStatusUseCase(
        conversationId: conversationId,
        status: status,
      );
    } catch (error) {
      emit(ChatFailure(error.toString()));
    }
  }

  @override
  Future<void> close() {
    _conversationSubscription?.cancel();
    _adminConversationsSubscription?.cancel();
    _messagesSubscription?.cancel();
    return super.close();
  }
}
