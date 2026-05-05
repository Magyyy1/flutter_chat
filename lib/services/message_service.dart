import 'package:pocketbase/pocketbase.dart';
import '../models/message_model.dart';
import 'pocketbase_service.dart';

class MessageService {
  final PocketBase _pb = PocketBaseService.instance.client;

  Future<List<MessageModel>> getMessages(String dialogId) async {
    final records = await _pb.collection('messages').getFullList(
      filter: 'dialog = "$dialogId"',
      sort: 'created',
      expand: 'sender',
    );
    return records.map((r) => MessageModel.fromRecord(r)).toList();
  }

  void subscribe(String dialogId, Function(MessageModel) onUpdate) {
    _pb.collection('messages').subscribe('*', (e) {
      final record = e.record;
      if (record != null && record.getStringValue('dialog') == dialogId) {
        onUpdate(MessageModel.fromRecord(record));
      }
    });
  }

  Future<MessageModel> sendMessage({
  required String dialogId,
  required String senderId,
  required String text,
}) async {
  final pb = PocketBaseService.instance.client;
  final record = await pb.collection('messages').create(body: {
    'dialog': dialogId,
    'sender': senderId,
    'text': text,
  });
  final fullRecord = await pb.collection('messages').getOne(record.id, expand: 'sender');
  return MessageModel.fromRecord(fullRecord);
}
}