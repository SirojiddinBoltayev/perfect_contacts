part of perfect_contacts;

class ContactState {
  final ContactStateStatus status;
  final List<Contact> contacts;
  final String? errorMessage;

  const ContactState({
    this.status = ContactStateStatus.idle,
    this.contacts = const [],
    this.errorMessage,
  });

  ContactState copyWith({
    ContactStateStatus? status,
    List<Contact>? contacts,
    String? errorMessage,
  }) {
    return ContactState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}