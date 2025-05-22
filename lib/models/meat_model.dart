class MeatRestaurantModel {
  final int id;
  final String? name;
  final String? address;
  final String? phoneNumber;
  final double? rating;
  final String? websiteLink;

  MeatRestaurantModel({
    required this.id,
    this.name,
    this.address,
    this.phoneNumber,
    this.rating,
    this.websiteLink,
  });

  factory MeatRestaurantModel.fromJson(Map<String, dynamic> json) {
    return MeatRestaurantModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      rating: (json['rating'] != null) ? double.tryParse(json['rating'].toString()) : null,
      websiteLink: json['website_link'],
    );
  }
}
