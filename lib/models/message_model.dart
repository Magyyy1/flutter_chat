import 'package:pocketbase/pocketbase.dart';

class MessageModel {
  final String id;
  final String dialogId;
  final String senderId;
  final String senderName;
  final String text;
  final bool isRead;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.dialogId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.isRead,
    required this.createdAt,
  });

  factory MessageModel.fromRecord(RecordModel record) {
    final senderRecord = record.expand['sender']?.isNotEmpty == true
        ? record.expand['sender']!.first
        : null;

    final senderName = senderRecord?.getStringValue('name').isNotEmpty == true
        ? senderRecord!.getStringValue('name')
        : (senderRecord?.getStringValue('email').isNotEmpty == true
            ? senderRecord!.getStringValue('email')
            : 'Пользователь');

    return MessageModel(
      id: record.id,
      dialogId: record.getStringValue('dialog'),
      senderId: record.getStringValue('sender'),
      senderName: senderName,
      text: record.getStringValue('text'),
      isRead: record.getBoolValue('is_read'),
      createdAt: DateTime.tryParse(record.created)?.toLocal() ?? DateTime.now(),
    );
  }
}