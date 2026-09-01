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
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _unreadOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  void _showUserProfileDialog(
    BuildContext context,
    ConversationEntity conversation,
    AppLocalizations l10n,
  ) {
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

  Widget _buildEmptyState(AppLocalizations l10n, {bool isFiltered = false}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            isFiltered ? l10n.noMatchingConversations : l10n.noConversations,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.customerMessagesAppearHere,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: hasUnread
              ? theme.colorScheme.primary.withValues(alpha: .3)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AdminChatDetailPage(conversation: conversation),
            ),
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
                    : '${l10n.customer} (${conversation.userId.length > 5 ? conversation.userId.substring(0, 5) : conversation.userId})',
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
                    : l10n.noMessagesPreview,
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
      ),
    );
  }

  Widget _buildFailureState(
    BuildContext context,
    AppLocalizations l10n,
    String message,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 56,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.somethingWentWrong,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () =>
                  context.read<ChatCubit>().watchAdminConversations(),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: (value) =>
              setState(() => _searchQuery = value.trim().toLowerCase()),
          decoration: InputDecoration(
            hintText: l10n.searchConversations,
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            filled: true,
            fillColor: theme.brightness == Brightness.dark
                ? theme.cardColor
                : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ChoiceChip(
              label: Text(l10n.allConversations),
              selected: !_unreadOnly,
              onSelected: (_) => setState(() => _unreadOnly = false),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: Text(l10n.unreadConversations),
              selected: _unreadOnly,
              onSelected: (_) => setState(() => _unreadOnly = true),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerChats), centerTitle: true),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading || state is ChatInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChatFailure) {
            return _buildFailureState(context, l10n, state.message);
          }

          if (state is ChatLoaded) {
            final conversations = state.adminConversations.where((
              conversation,
            ) {
              final searchableText =
                  '${conversation.userName} ${conversation.userEmail} '
                          '${conversation.lastMessage}'
                      .toLowerCase();
              final matchesSearch =
                  _searchQuery.isEmpty || searchableText.contains(_searchQuery);
              final matchesFilter =
                  !_unreadOnly || conversation.unreadForAdmin > 0;
              return matchesSearch && matchesFilter;
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: _buildToolbar(context, l10n),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 4,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      l10n.conversationCount(conversations.length),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: conversations.isEmpty
                      ? _buildEmptyState(
                          l10n,
                          isFiltered: _searchQuery.isNotEmpty || _unreadOnly,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                          itemCount: conversations.length,
                          itemBuilder: (context, index) =>
                              _buildConversationTile(
                                context,
                                conversations[index],
                                l10n,
                              ),
                        ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
