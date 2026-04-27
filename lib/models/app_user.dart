import 'package:pocketbase/pocketbase.dart';

class AppUser {
  final String id;
  final String name;
  final String email;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory AppUser.fromRecord(RecordModel record) {
    return AppUser(
      id: record.id,
      name: record.getStringValue('name'),
      email: record.getStringValue('email'),
    );
  }
}