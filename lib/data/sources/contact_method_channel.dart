part of perfect_contacts;

class _ContactMethodChannel {
  static const _methodChannel = MethodChannel('perfect_contacts');

  Future<List<dynamic>> getContacts() async {
    final result = await _methodChannel.invokeMethod('getContacts');
    if (result is List) {
      return result;
    }
    throw Exception('Invalid response from native platform');
  }
}