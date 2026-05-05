import 'package:pocketbase/pocketbase.dart';
import '../models/app_user.dart';
import 'pocketbase_service.dart';

class UserService {
  final PocketBase _pb = PocketBaseService.instance.client;

  Future<List<AppUser>> searchUsers(String query) async {
    final result = await _pb.collection('users').getList(
      filter: "name ~ '$query' || email ~ '$query'",
    );

    return result.items
        .map((e) => AppUser.fromRecord(e))
        .toList();
  }
}