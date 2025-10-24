part of perfect_contacts;

class ContactModel extends Contact {
  const ContactModel({
    required super.fullName,
    required super.firstName,
    required super.lastName,
    required super.phoneNumber,
    required super.countryCode,
    required super.countryName,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      fullName: json['fullName']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      countryCode: json['countryCode']?.toString() ?? 'Unknown',
      countryName: json['countryName']?.toString() ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'countryName': countryName,
    };
  }

  static List<ContactModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ContactModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}