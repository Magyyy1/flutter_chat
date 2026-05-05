import 'package:pocketbase/pocketbase.dart';

class DialogModel {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String lastText;
  final DateTime? lastMessageAt;

  DialogModel({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    required this.lastText,
    this.lastMessageAt,
  });

  factory DialogModel.fromRecord(RecordModel record, String currentUserId) {
    final user1Id = record.getStringValue('user1');
    final user2Id = record.getStringValue('user2');
    final otherUserId = user1Id == currentUserId ? user2Id : user1Id;

    final user1 = record.get<RecordModel>('user1');
    final user2 = record.get<RecordModel>('user2');
    
    final otherUser = (user1.id == otherUserId ? user1 : user2);
    final otherUserName = otherUser.getStringValue('name');

    DateTime? lastMessageAt;
    final rawDate = record.getStringValue('last_message_at');
    if (rawDate.isNotEmpty) {
      lastMessageAt = DateTime.tryParse(rawDate);
    }

    return DialogModel(
      id: record.id,
      otherUserId: otherUserId,
      otherUserName: otherUserName,
      lastText: record.getStringValue('last_text'),
      lastMessageAt: lastMessageAt,
    );
  }
}