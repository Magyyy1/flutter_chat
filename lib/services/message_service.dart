import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/message_model.dart';
import 'pocketbase_service.dart';

class MessageService {
  final PocketBase _pb = PocketBaseService.instance.client;

  Future<List<MessageModel>> getMessages(String dialogId) async {
    final filter = _pb.filter(
      'dialog = {:dialogId}',
      {'dialogId': dialogId},
    );

    final records = await _pb.collection('messages').getFullList(
      expand: 'sender',
      filter: filter,
      sort: 'created',
    );

    return records.map(MessageModel.fromRecord).toList();
  }

  Future<void> sendMessage({
    required String dialogId,
    required String senderId,
    required String text,
  }) async {
    await _pb.collection('messages').create(
      body: {
        'dialog': dialogId,
        'sender': senderId,
        'text': text,
        'is_read': false,
      },
    );

    await _pb.collection('dialogs').update(
      dialogId,
      body: {
        'last_text': text,
        'last_message_at': DateTime.now().toUtc().toIso8601String(),
      },
    );
  }

  Future<dynamic> subscribeToDialog(
    String dialogId,
    VoidCallback onEvent,
  ) async {
    final filter = _pb.filter(
      'dialog = {:dialogId}',
      {'dialogId': dialogId},
    );

    return _pb.collection('messages').subscribe(
      '*',
      (event) => onEvent(),
      filter: filter,
    );
  }
}