import 'package:flutter/material.dart';
import 'package:perfect_contacts/perfect_contacts.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ContactsScreen(),
    );
  }
}

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kontaktlar'),
        centerTitle: true,
      ),
      body: StreamBuilder<ContactState>(
        stream: PerfectContactsPlugin().contactsStream,
        builder: (context, snapshot) {
          final state = snapshot.data;

          if (state == null || state.status == ContactStateStatus.idle) {
            return const Center(
              child: Text(
                'Maʼlumotlarni yuklash kutilmoqda...',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          switch (state.status) {
            case ContactStateStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case ContactStateStatus.error:
              return Center(
                child: Text(
                  state.errorMessage ?? 'Nomaʼlum xatolik yuz berdi',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              );
            case ContactStateStatus.success:
              final contacts = state.contacts;
              if (contacts.isEmpty) {
                return const Center(
                  child: Text(
                    'Kontaktlar topilmadi',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(contact.fullName.isNotEmpty
                            ? contact.fullName[0]
                            : '?'),
                      ),
                      title: Text(
                        contact.fullName.isNotEmpty
                            ? contact.fullName
                            : 'Ism kiritilmagan',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${contact.phoneNumber} (${contact.countryCode})',
                      ),
                    ),
                  );
                },
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}