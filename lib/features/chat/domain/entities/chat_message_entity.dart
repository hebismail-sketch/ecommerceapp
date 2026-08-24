import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String senderRole;
  final String text;
  final String type;
  final DateTime? createdAt;
  final bool isRead;

  final String? productId;
  final String? productNameAr;
  final String? productNameEn;
  final String? productImage;
  final double? productPrice;

  const ChatMessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.text,
    required this.type,
    required this.createdAt,
    required this.isRead,
    this.productId,
    this.productNameAr,
    this.productNameEn,
    this.productImage,
    this.productPrice,
  });

  bool get isTextMessage => type == 'text';

  bool get isProductMessage => type == 'product';

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        senderName,
        senderRole,
        text,
        type,
        createdAt,
        isRead,
        productId,
        productNameAr,
        productNameEn,
        productImage,
        productPrice,
      ];
}