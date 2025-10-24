part of perfect_contacts;

abstract class _Failure {
  final String message;

  const _Failure(this.message);
}

class PermissionDeniedFailure extends _Failure {
  const PermissionDeniedFailure() : super('Permission denied');
}

class ContactFetchFailure extends _Failure {
  const ContactFetchFailure({required String message}) : super(message);
}