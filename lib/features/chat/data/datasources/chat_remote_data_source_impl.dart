import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/core/constants/app_constants.dart';

import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';
import 'chat_remote_data_source.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl({
    required this.firestore,
  });

  CollectionReference<Map<String, dynamic>> get _conversationsCollection =>
      firestore.collection('conversations');

  CollectionReference<Map<String, dynamic>> _messagesCollection(
    String conversationId,
  ) {
    return _conversationsCollection
        .doc(conversationId)
        .collection('messages');
  }

  @override
  Stream<ConversationModel?> watchConversation(String userId) {
    return _conversationsCollection.doc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }

      return ConversationModel.fromJson(
        snapshot.id,
        snapshot.data()!,
      );
    });
  }

  @override
  Stream<List<ConversationModel>> watchAdminConversations() {
    return _conversationsCollection
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ConversationModel.fromJson(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  @override
  Stream<List<ChatMessageModel>> watchMessages(
    String conversationId,
  ) {
    return _messagesCollection(conversationId)
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ChatMessageModel.fromJson(
                  doc.id,
                  conversationId,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  @override
  Future<void> sendMessage({
    required String conversationId,
    required ChatMessageModel message,
    required ConversationModel conversation,
  }) async {
    final batch = firestore.batch();

    final conversationReference =
        _conversationsCollection.doc(conversationId);

    final messageReference = _messagesCollection(conversationId).doc();

    final messageData = message.toJson()
      ..['conversationId'] = conversationId
      ..['createdAt'] = FieldValue.serverTimestamp();

    final conversationData = conversation.toJson()
      ..['lastMessageAt'] = FieldValue.serverTimestamp();

    batch.set(messageReference, messageData);

    batch.set(
      conversationReference,
      conversationData,
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  @override
  Future<void> markMessagesAsRead({
    required String conversationId,
    required String readerRole,
  }) async {
    final messagesSnapshot = await _messagesCollection(conversationId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = firestore.batch();

    for (final document in messagesSnapshot.docs) {
      final senderRole = document.data()['senderRole'];

      if (senderRole != readerRole) {
        batch.update(
          document.reference,
          {'isRead': true},
        );
      }
    }

    final unreadField = readerRole == AppConstants.adminRole
        ? 'unreadForAdmin'
        : 'unreadForUser';

    batch.update(
      _conversationsCollection.doc(conversationId),
      {unreadField: 0},
    );

    await batch.commit();
  }

  @override
  Future<void> updateConversationStatus({
    required String conversationId,
    required String status,
  }) async {
    await _conversationsCollection.doc(conversationId).update({
      'status': status,
    });
  }
}