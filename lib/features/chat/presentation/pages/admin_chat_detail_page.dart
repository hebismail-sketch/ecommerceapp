// File: lib/features/chat/presentation/pages/admin_chat_detail_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:ecommerceapp/core/constants/app_constants.dart';
import 'package:ecommerceapp/features/chat/data/models/chat_message_model.dart';
import 'package:ecommerceapp/features/chat/data/models/conversation_model.dart';
import 'package:ecommerceapp/features/chat/domain/entities/chat_message_entity.dart';
import 'package:ecommerceapp/features/chat/domain/entities/conversation_entity.dart';
import 'package:ecommerceapp/features/chat/presentation/manager/chat_cubit.dart';
import 'package:ecommerceapp/features/chat/presentation/manager/chat_state.dart';

class AdminChatDetailPage extends StatefulWidget {
  const AdminChatDetailPage({super.key});

  static const String screenRoute = 'adminChatDetail';

  @override
  State<AdminChatDetailPage> createState() => _AdminChatDetailPageState();
}

class _AdminChatDetailPageState extends State<AdminChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  ConversationEntity? _conversation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_conversation == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is ConversationEntity) {
        _conversation = args;
        // Watch messages for this specific conversation
        context.read<ChatCubit>().watchMessages(_conversation!.id);
        // Mark existing messages as read by admin
        context.read<ChatCubit>().markMessagesAsRead(
              conversationId: _conversation!.id,
              readerRole: AppConstants.adminRole,
            );
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    final text = _messageController.text.trim();
    if (user == null || text.isEmpty || _conversation == null) return;

    final conversationId = _conversation!.id;
    final senderName = user.displayName?.isNotEmpty == true
        ? user.displayName!
        : 'Support Team';

    final message = ChatMessageModel(
      id: '',
      conversationId: conversationId,
      senderId: user.uid,
      senderName: senderName,
      senderRole: AppConstants.adminRole,
      text: text,
      type: 'text',
      createdAt: DateTime.now(),
      isRead: false,
    );

    final updatedConversation = ConversationModel(
      id: conversationId,
      userId: _conversation!.userId,
      userName: _conversation!.userName,
      userEmail: _conversation!.userEmail,
      lastMessage: text,
      lastMessageAt: DateTime.now(),
      lastSenderId: user.uid,
      unreadForUser: _conversation!.unreadForUser + 1,
      unreadForAdmin: 0,
      status: _conversation!.status,
    );

    _messageController.clear();
    await context.read<ChatCubit>().sendMessage(
          conversationId: conversationId,
          message: message,
          conversation: updatedConversation,
        );
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('hh:mm a').format(dateTime);
  }

  Widget _buildMessageBubble({
    required ChatMessageEntity message,
    required bool isMine,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMine
              ? theme.colorScheme.primary
              : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAlignment.end : CrossAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: isMine
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black87),
                fontSize: 15,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.createdAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: isMine
                        ? Colors.white70
                        : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                  ),
                ),
                if (isMine) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? Icons.done_all : Icons.done,
                    size: 14,
                    color: message.isRead
                        ? Colors.lightBlueAccent
                        : Colors.white70,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessages(ChatLoaded state) {
    if (state.messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'No messages in this chat',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];
        final isMine = message.senderRole == AppConstants.adminRole;
        return _buildMessageBubble(
          message: message,
          isMine: isMine,
        );
      },
    );
  }

  Widget _buildMessageInput() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Type response to customer...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: theme.colorScheme.primary,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _sendMessage,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_conversation == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chat Details')),
        body: const Center(child: Text('No conversation selected')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _conversation!.userName.isNotEmpty
                  ? _conversation!.userName
                  : 'Customer Chat',
              style: const TextStyle(fontSize: 16),
            ),
            if (_conversation!.userEmail.isNotEmpty)
              Text(
                _conversation!.userEmail,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
          ],
        ),
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatLoaded) {
            _scrollToBottom();
          }
          if (state is ChatFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ChatLoading || state is ChatInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ChatFailure) {
            return Center(child: Text(state.message));
          }
          if (state is ChatLoaded) {
            return Column(
              children: [
                Expanded(child: _buildMessages(state)),
                _buildMessageInput(),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
