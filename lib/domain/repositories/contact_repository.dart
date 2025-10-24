part of perfect_contacts;


abstract class _ContactRepository {
  Future<_Either<_Failure, List<Contact>>> getContacts();
}