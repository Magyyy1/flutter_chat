import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';

class PocketBaseService {
  PocketBaseService._(this.client);

  static late final PocketBaseService instance;

  final PocketBase client;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    final store = AsyncAuthStore(
      save: (String data) async => prefs.setString('pb_auth', data),
      clear: () async => prefs.remove('pb_auth'),
      initial: prefs.getString('pb_auth'),
    );

    final client = PocketBase(
      pocketBaseUrl,
      authStore: store,
    );

    instance = PocketBaseService._(client);
  }
}