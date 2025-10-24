part of perfect_contacts;


class Contact {
  final String fullName;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String countryCode;
  final String countryName;

  const Contact({
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.countryCode,
    required this.countryName,
  });
}