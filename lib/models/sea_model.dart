class SeafoodRestaurantModel {
  final int id;
  final String name;
  final String? address;
  final String? phoneNumber;
  final double? rating;
  final String? websiteLink;

  SeafoodRestaurantModel({
    required this.id,
    required this.name,
    this.address,
    this.phoneNumber,
    this.rating,
    this.websiteLink,
  });

  factory SeafoodRestaurantModel.fromJson(Map<String, dynamic> json) {
    return SeafoodRestaurantModel(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String?,
      phoneNumber: json['phone_number'] as String?,
      rating: json['rating'] as double?,
      websiteLink: json['website_link'] as String?,
    );
  }
}
