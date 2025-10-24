part of perfect_contacts;

class _ContactRepositoryImpl implements _ContactRepository {
  final _ContactMethodChannel methodChannel;

  _ContactRepositoryImpl(this.methodChannel);

  @override
  Future<_Either<_Failure, List<Contact>>> getContacts() async {
    try {
      final hasPermission = await Permission.contacts.request();
      if (!hasPermission.isGranted) {
        return const _Left(PermissionDeniedFailure());
      }

      final contactsJson = await methodChannel.getContacts();

      final contacts = (contactsJson)
          .map((e) => ContactModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      return _Right(contacts);
    } catch (e) {
      return _Left(ContactFetchFailure(message: e.toString()));
    }
  }
}