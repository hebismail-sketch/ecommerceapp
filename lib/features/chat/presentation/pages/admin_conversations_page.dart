// File: lib/features/chat/presentation/pages/admin_conversations_page.dart

import 'package:ecommerceapp/features/chat/domain/entities/conversation_entity.dart';
import 'package:ecommerceapp/features/chat/presentation/manager/chat_cubit.dart';
import 'package:ecommerceapp/features/chat/presentation/manager/chat_state.dart';
import 'package:ecommerceapp/features/chat/presentation/pages/admin_chat_detail_page.dart';
import 'package:ecommerceapp/features/chat/presentation/widgets/user_avatar_widget.dart';
import 'package:ecommerceapp/features/chat/presentation/widgets/user_profile_modal.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AdminConversationsPage extends StatefulWidget {
  const AdminConversationsPage({super.key});

  static const String screenRoute = 'adminConversations';

  @override
  State<AdminConversationsPage> createState() => _AdminConversationsPageState();
}

class _AdminConversationsPageState extends State<AdminConversationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Start watching all admin conversations
      context.read<ChatCubit>().watchAdminConversations();
    });
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat('hh:mm a').format(dateTime);
    } else if (difference.inDays < 7) {
      return DateFormat('EEE, hh:mm a').format(dateTime);
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  void _showUserProfileDialog(BuildContext context, ConversationEntity conversation, AppLocalizations l10n) {
    UserProfileModal.show(
      context: context,
      conversation: conversation,
      l10n: l10n,
      onChatPressed: () {
        Navigator.pushNamed(
          context,
          AdminChatDetailPage.screenRoute,
          arguments: conversation,
        );
      },
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.noConversations,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.customerMessagesAppearHere,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(
    BuildContext context,
    ConversationEntity conversation,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasUnread = conversation.unreadForAdmin > 0;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      onTap: () {
        Navigator.pushNamed(
          context,
          AdminChatDetailPage.screenRoute,
          arguments: conversation,
        );
      },
      leading: GestureDetector(
        onTap: () {
          _showUserProfileDialog(context, conversation, l10n);
        },
        child: Stack(
          children: [
            UserAvatarWidget(
              userId: conversation.userId,
              fallbackName: conversation.userName,
              radius: 24,
            ),
            if (hasUnread)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? Colors.grey.shade900 : Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              conversation.userName.isNotEmpty
                  ? conversation.userName
                  : '${l10n.customer} (${conversation.userId.substring(0, 5)})',
              style: TextStyle(
                fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                fontSize: 15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            _formatDate(conversation.lastMessageAt),
            style: TextStyle(
              fontSize: 12,
              color: hasUnread
                  ? theme.colorScheme.primary
                  : Colors.grey.shade500,
              fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              conversation.lastMessage.isNotEmpty
                  ? conversation.lastMessage
                  : 'No messages',
              style: TextStyle(
                fontSize: 13,
                color: hasUnread
                    ? (isDark ? Colors.white : Colors.black87)
                    : Colors.grey.shade600,
                fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (hasUnread)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${conversation.unreadForAdmin}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customerChats),
        centerTitle: true,
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading || state is ChatInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChatFailure) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is ChatLoaded) {
            final conversations = state.adminConversations;

            if (conversations.isEmpty) {
              return _buildEmptyState(l10n);
            }

            return ListView.separated(
              itemCount: conversations.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return _buildConversationTile(context, conversations[index], l10n);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

