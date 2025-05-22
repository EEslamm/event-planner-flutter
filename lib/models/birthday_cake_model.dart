class BirthdayCakeModel {
  final int id;
  final String? name;
  final String? address;
  final String? phoneNumber;
  final String? websiteLink;

  BirthdayCakeModel({
    required this.id,
    this.name,
    this.address,
    this.phoneNumber,
    this.websiteLink,
  });

  factory BirthdayCakeModel.fromJson(Map<String, dynamic> json) {
    return BirthdayCakeModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      websiteLink: json['website_link'],
    );
  }
}
