import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.conversationId,
    required super.senderId,
    required super.senderName,
    required super.senderRole,
    required super.text,
    required super.type,
    required super.createdAt,
    required super.isRead,
    super.productId,
    super.productNameAr,
    super.productNameEn,
    super.productImage,
    super.productPrice,
  });

  factory ChatMessageModel.fromJson(
    String id,
    String conversationId,
    Map<String, dynamic> data,
  ) {
    final timestamp = data['createdAt'];

    return ChatMessageModel(
      id: id,
      conversationId: conversationId,
      senderId: data['senderId'] as String? ?? '',
      senderName: data['senderName'] as String? ?? '',
      senderRole: data['senderRole'] as String? ?? '',
      text: data['text'] as String? ?? '',
      type: data['type'] as String? ?? 'text',
      createdAt: timestamp is Timestamp ? timestamp.toDate() : null,
      isRead: data['isRead'] as bool? ?? false,
      productId: data['productId'] as String?,
      productNameAr: data['productNameAr'] as String?,
      productNameEn: data['productNameEn'] as String?,
      productImage: data['productImage'] as String?,
      productPrice: (data['productPrice'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      'senderRole': senderRole,
      'text': text,
      'type': type,
      'createdAt': createdAt == null
          ? null
          : Timestamp.fromDate(createdAt!),
      'isRead': isRead,
      'productId': productId,
      'productNameAr': productNameAr,
      'productNameEn': productNameEn,
      'productImage': productImage,
      'productPrice': productPrice,
    };
  }
}