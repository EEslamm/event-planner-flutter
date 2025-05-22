class PhotographerModel {
  final int id;
  final String? name;
  final String? phoneNumber;
  final double? hourlyRate;
  final double? rating;
  final String? websiteLink;

  PhotographerModel({
    required this.id,
    this.name,
    this.phoneNumber,
    this.hourlyRate,
    this.rating,
    this.websiteLink,
  });

  factory PhotographerModel.fromJson(Map<String, dynamic> json) {
    return PhotographerModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      hourlyRate: json['hourly_rate'] != null ? double.tryParse(json['hourly_rate'].toString()) : null,
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) : null,
      websiteLink: json['website_link'],
    );
  }
}
