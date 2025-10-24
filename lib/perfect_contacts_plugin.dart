
part of perfect_contacts;

class PerfectContactsPlugin {
  final _GetContactsUseCase _getContactsUseCase;

  PerfectContactsPlugin()
      : _getContactsUseCase = _GetContactsUseCase(
    _ContactRepositoryImpl(_ContactMethodChannel()),
  );

  Stream<ContactState> get contactsStream async* {
    yield const ContactState(status: ContactStateStatus.loading);
    final result = await _getContactsUseCase();
    yield* result.fold(
          (failure) async* {
        yield ContactState(
          status: ContactStateStatus.error,
          errorMessage: failure.message,
        );
      },
          (contacts) async* {
        yield ContactState(
          status: ContactStateStatus.success,
          contacts: contacts,
        );
      },
    );
  }
}