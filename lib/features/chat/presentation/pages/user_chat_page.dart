import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerceapp/core/constants/app_constants.dart';
import 'package:ecommerceapp/features/chat/data/models/chat_message_model.dart';
import 'package:ecommerceapp/features/chat/data/models/conversation_model.dart';
import 'package:ecommerceapp/features/chat/presentation/manager/chat_cubit.dart';
import 'package:ecommerceapp/features/chat/presentation/manager/chat_state.dart';

class UserChatPage extends StatefulWidget {
  const UserChatPage({super.key});

  static const String screenRoute = 'userChat';

  @override
  State<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _watchedConversationId;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<ChatCubit>().watchConversation(user.uid);
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getUserName(User user) {
    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      return user.displayName!.trim();
    }
    if (user.email != null && user.email!.trim().isNotEmpty) {
      return user.email!.split('@').first;
    }
    return 'User';
  }

  Future<void> _sendMessage(ChatLoaded state) async {
    final user = FirebaseAuth.instance.currentUser;
    final text = _messageController.text.trim();
    if (user == null || text.isEmpty) return;

    final conversation = state.conversation;
    final conversationId = conversation?.id ?? user.uid;
    final userName = _getUserName(user);
    final userEmail = user.email ?? '';

    final message = ChatMessageModel(
      id: '',
      conversationId: conversationId,
      senderId: user.uid,
      senderName: userName,
      senderRole: AppConstants.userRole,
      text: text,
      type: 'text',
      createdAt: DateTime.now(),
      isRead: false,
    );

    final updatedConversation = ConversationModel(
      id: conversationId,
      userId: user.uid,
      userName: conversation?.userName ?? userName,
      userEmail: conversation?.userEmail ?? userEmail,
      lastMessage: text,
      lastMessageAt: DateTime.now(),
      lastSenderId: user.uid,
      unreadForUser: conversation?.unreadForUser ?? 0,
      unreadForAdmin: (conversation?.unreadForAdmin ?? 0) + 1,
      status: conversation?.status ?? 'open',
    );

    _messageController.clear();
    await context.read<ChatCubit>().sendMessage(
      conversationId: conversationId,
      message: message,
      conversation: updatedConversation,
    );
    _scrollToBottom();
  }

  void _watchMessagesIfNeeded(ChatLoaded state) {
    final conversation = state.conversation;
    if (conversation == null || _watchedConversationId == conversation.id) {
      return;
    }

    _watchedConversationId = conversation.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<ChatCubit>();
      cubit.watchMessages(conversation.id);
      cubit.markMessagesAsRead(
        conversationId: conversation.id,
        readerRole: AppConstants.userRole,
      );
    });
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
  Widget _buildMessageBubble({
    required String text,
    required bool isMine,
  }) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMine ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 3),
            bottomRight: Radius.circular(isMine ? 3 : 16),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isMine ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildMessages(ChatLoaded state) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Please log in first'));
    }
    if (state.messages.isEmpty) {
      return const Center(child: Text('No messages yet'));
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];
        return _buildMessageBubble(
          text: message.text,
          isMine: message.senderId == user.uid,
        );
      },
    );
  }

  Widget _buildMessageInput(ChatLoaded state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(state),
                decoration: InputDecoration(
                  hintText: 'Write a message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              child: IconButton(
                onPressed: () => _sendMessage(state),
                icon: const Icon(Icons.send),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chat with Support')),
        body: const Center(child: Text('Please log in first')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Chat with Support')),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatLoaded) {
            _watchMessagesIfNeeded(state);
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
                _buildMessageInput(state),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
