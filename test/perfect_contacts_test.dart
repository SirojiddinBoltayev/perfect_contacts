// import 'package:flutter_test/flutter_test.dart';
// import 'package:perfect_contacts/perfect_contacts.dart';
// import 'package:perfect_contacts/perfect_contacts_platform_interface.dart';
// import 'package:perfect_contacts/perfect_contacts_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockPerfectContactsPlatform
//     with MockPlatformInterfaceMixin
//     implements PerfectContactsPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final PerfectContactsPlatform initialPlatform = PerfectContactsPlatform.instance;
//
//   test('$MethodChannelPerfectContacts is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelPerfectContacts>());
//   });
//
//   test('getPlatformVersion', () async {
//     PerfectContacts perfectContactsPlugin = PerfectContacts();
//     MockPerfectContactsPlatform fakePlatform = MockPerfectContactsPlatform();
//     PerfectContactsPlatform.instance = fakePlatform;
//
//     expect(await perfectContactsPlugin.getPlatformVersion(), '42');
//   });
// }
