class HallModel {
  final int id;
  final String name;
  final String? photo;
  final double? rate;
  final String? location;
  final double? price;
  final String? phone;
  final int capacity;

  HallModel({
    required this.id,
    required this.name,
    required this.capacity,
    this.photo,
    this.rate,
    this.location,
    this.price,
    this.phone,
  });

  factory HallModel.fromJson(Map<String, dynamic> json) {
    return HallModel(
      id: json['id'] as int,
      name: json['hall_name'] as String,
      capacity: json['hall_capacity'] as int,
      photo: json['hall_photo'] as String?,
      rate: (json['hall_rate'] as num?)?.toDouble(),
      location: json['hall_location'] as String?,
      price: (json['hall_price'] as num?)?.toDouble(),
      phone: json['hall_phone'] as String?,
    );
  }

  @override
  String toString() => 'HallModel(id: $id, name: $name)';
}
