class FavoriteModel {
  final String id;
  final String carId;

  const FavoriteModel({
    required this.id,
    required this.carId,
  });

  Map<String, dynamic> toMap() {
    return {
      'carId': carId,
    };
  }

  factory FavoriteModel.fromMap(
      String id,
      Map<String, dynamic> data,
      ) {
    return FavoriteModel(
      id: id,
      carId: data['carId'] ?? '',
    );
  }
}