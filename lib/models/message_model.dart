import 'package:pocketbase/pocketbase.dart';

class MessageModel {
  final String id;
  final String? tempId;    
  final String dialogId; 
  final String senderId;
  final String senderName;
  final String text;
  final DateTime createdAt;
  final bool isSending;    
  final bool hasError;     

  MessageModel({
    required this.id,
    this.tempId,
    required this.dialogId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.createdAt,
    this.isSending = false,
    this.hasError = false,
  });

  MessageModel copyWith({
    String? id,
    String? tempId,
    String? dialogId,
    String? senderId,
    String? senderName,
    String? text,
    DateTime? createdAt,
    bool? isSending,
    bool? hasError,
  }) {
    return MessageModel(
      id: id ?? this.id,
      tempId: tempId ?? this.tempId,
      dialogId: dialogId ?? this.dialogId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      isSending: isSending ?? this.isSending,
      hasError: hasError ?? this.hasError,
    );
  }

  factory MessageModel.fromRecord(RecordModel record) {
    final sender = record.get<RecordModel>('sender');
    final rawCreated = record.getStringValue('created');
    final createdAt = rawCreated.isNotEmpty
        ? DateTime.tryParse(rawCreated) ?? DateTime.now()
        : DateTime.now();

    return MessageModel(
      id: record.id,
      dialogId: record.getStringValue('dialog'),
      senderId: record.getStringValue('sender'),
      senderName: sender.getStringValue('name'),
      text: record.getStringValue('text'),
      createdAt: createdAt,
    );
  }
}