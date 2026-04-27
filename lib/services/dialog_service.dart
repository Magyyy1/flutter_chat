import 'package:pocketbase/pocketbase.dart';

import '../models/dialog_model.dart';
import 'pocketbase_service.dart';

class DialogService {
  final PocketBase _pb = PocketBaseService.instance.client;

  Future<List<DialogModel>> getDialogs(String currentUserId) async {
    final filter = _pb.filter(
      'user1 = {:userId} || user2 = {:userId}',
      {'userId': currentUserId},
    );

    final records = await _pb.collection('dialogs').getFullList(
      expand: 'user1,user2',
      filter: filter,
      sort: '-last_message_at,-updated',
    );

    return records
        .map((record) => DialogModel.fromRecord(record, currentUserId))
        .toList();
  }
}