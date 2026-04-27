import 'package:pocketbase/pocketbase.dart';

class DialogModel {
  final String id;
  final String user1Id;
  final String user2Id;
  final String otherUserId;
  final String otherUserName;
  final String lastText;
  final DateTime? lastMessageAt;

  DialogModel({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.otherUserId,
    required this.otherUserName,
    required this.lastText,
    required this.lastMessageAt,
  });

  factory DialogModel.fromRecord(RecordModel record, String currentUserId) {
    final user1Id = record.getStringValue('user1');
    final user2Id = record.getStringValue('user2');

    final user1Record = record.expand['user1']?.isNotEmpty == true
        ? record.expand['user1']!.first
        : null;

    final user2Record = record.expand['user2']?.isNotEmpty == true
        ? record.expand['user2']!.first
        : null;

    final isCurrentUserFirst = user1Id == currentUserId;
    final otherRecord = isCurrentUserFirst ? user2Record : user1Record;
    final otherId = isCurrentUserFirst ? user2Id : user1Id;

    final otherName = otherRecord?.getStringValue('name').isNotEmpty == true
        ? otherRecord!.getStringValue('name')
        : (otherRecord?.getStringValue('email').isNotEmpty == true
            ? otherRecord!.getStringValue('email')
            : 'Пользователь');

    final rawDate = record.getStringValue('last_message_at');

    return DialogModel(
      id: record.id,
      user1Id: user1Id,
      user2Id: user2Id,
      otherUserId: otherId,
      otherUserName: otherName,
      lastText: record.getStringValue('last_text'),
      lastMessageAt: rawDate.isNotEmpty ? DateTime.tryParse(rawDate) : null,
    );
  }
}