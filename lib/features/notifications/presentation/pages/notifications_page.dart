// File: lib/features/notifications/presentation/pages/notifications_page.dart

import 'package:ecommerceapp/core/notifications/notification_service.dart';
import 'package:ecommerceapp/core/theme/app_colors.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static const String screenRoute = 'notificationsPage';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          l10n.notificationsTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? AppColors.darkBackground : null,
        elevation: 0,
      ),
      body: user == null
          ? _EmptyNotifications(l10n: l10n, isDark: isDark)
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('notifications')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final notifications = snapshot.data?.docs ?? [];
                if (notifications.isEmpty) {
                  return _EmptyNotifications(l10n: l10n, isDark: isDark);
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final data = notifications[index].data();
                    final read = data['read'] == true;
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : Colors.transparent,
                        ),
                      ),
                      tileColor: read
                          ? (isDark ? AppColors.darkCard : Colors.white)
                          : (isDark
                              ? AppColors.darkSurface
                              : Colors.red.shade50),
                      leading: Icon(
                        read
                            ? Icons.notifications_none
                            : Icons.notifications_active,
                        color: isDark ? AppColors.gold : Colors.red.shade600,
                      ),
                      title: Text(
                        data['title']?.toString() ?? l10n.notificationsTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(data['body']?.toString() ?? ''),
                      onTap: () {
                        notifications[index].reference.update({
                          'read': true,
                        });

                        final rawData = data['data'];
                        final Map<String, dynamic> targetData = {};
                        if (rawData is Map<String, dynamic>) {
                          targetData.addAll(rawData);
                        }
                        if (!targetData.containsKey('type') &&
                            data['type'] != null) {
                          targetData['type'] = data['type'];
                        }

                        if (targetData.isNotEmpty) {
                          NotificationService.handleNotificationData(targetData);
                        }
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications({required this.l10n, required this.isDark});

  final AppLocalizations l10n;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.gold.withValues(alpha: 0.12)
                    : Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_active_outlined,
                size: 64,
                color: isDark ? AppColors.gold : Colors.red.shade600,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.noNotifications,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.notificationsSubtitle,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
