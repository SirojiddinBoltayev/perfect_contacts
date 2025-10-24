part of perfect_contacts;

class _GetContactsUseCase {
  final _ContactRepository repository;

  _GetContactsUseCase(this.repository);

  Future<_Either<_Failure, List<Contact>>> call() async {
    return await repository.getContacts();
  }
}