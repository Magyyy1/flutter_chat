import 'package:pocketbase/pocketbase.dart';
import '../models/dialog_model.dart';
import 'pocketbase_service.dart';

class DialogService {
  final PocketBase _pb = PocketBaseService.instance.client;

Future<List<DialogModel>> getDialogs(String userId) async {
  final pb = PocketBaseService.instance.client;
  final records = await pb.collection('dialogs').getFullList(
    filter: 'user1 = "$userId" || user2 = "$userId"',
    expand: 'user1,user2',
    sort: '-last_message_at',
  );
  return records.map((r) => DialogModel.fromRecord(r, userId)).toList();
}

  void subscribe(String userId, Function(DialogModel) onUpdate) {
  _pb.collection('dialogs').subscribe('*', (e) {
    final record = e.record;
    if (record == null) return;
    final user1 = record.getStringValue('user1');
    final user2 = record.getStringValue('user2');
    if (user1 == userId || user2 == userId) {
      onUpdate(DialogModel.fromRecord(record, userId));
    }
  });
}

  Future<DialogModel> findOrCreateDialog(String currentUserId, String otherUserId) async {
  final pb = PocketBaseService.instance.client;

  final existing = await pb.collection('dialogs').getFullList(
    filter: '(user1 = "$currentUserId" && user2 = "$otherUserId") || ' 
            '(user1 = "$otherUserId" && user2 = "$currentUserId")',
    expand: 'user1,user2',
  );

  if (existing.isNotEmpty) {
    return DialogModel.fromRecord(existing.first, currentUserId);
  }

  final newRecord = await pb.collection('dialogs').create(body: {
    'user1': currentUserId,
    'user2': otherUserId,
    'last_text': '',
    'last_message_at': DateTime.now().toIso8601String(),
  });

  final fullRecord = await pb.collection('dialogs').getOne(newRecord.id, expand: 'user1,user2');
  return DialogModel.fromRecord(fullRecord, currentUserId);
}
}