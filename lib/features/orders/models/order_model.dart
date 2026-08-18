class OrderModel {
  final String id;
  final String userId;
  final List<String> carIds;
  final double totalPrice;
  final DateTime orderDate;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.carIds,
    required this.totalPrice,
    required this.orderDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'carIds': carIds,
      'totalPrice': totalPrice,
      'orderDate': orderDate.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(
      String id,
      Map<String, dynamic> data,
      ) {
    return OrderModel(
      id: id,
      userId: data['userId'] ?? '',
      carIds: List<String>.from(
        data['carIds'] ?? [],
      ),
      totalPrice:
      (data['totalPrice'] as num?)?.toDouble() ?? 0,
      orderDate:
      DateTime.tryParse(
        data['orderDate'] ?? '',
      ) ??
          DateTime.now(),
    );
  }
}