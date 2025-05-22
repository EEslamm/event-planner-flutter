class BirthdayVenue {
  final String name;
  final String address;
  final String phoneNumber;
  final String websiteLink;

  BirthdayVenue({
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.websiteLink,
  });
}
class BirthdayVenueModel {
  final int id;
  final String? name;
  final String? address;
  final String? phoneNumber;
  final String? websiteLink;

  BirthdayVenueModel({
    required this.id,
    this.name,
    this.address,
    this.phoneNumber,
    this.websiteLink,
  });

  factory BirthdayVenueModel.fromJson(Map<String, dynamic> json) {
    return BirthdayVenueModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      websiteLink: json['website_link'],
    );
  }
}
