import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/dialog_model.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.dialog,
    required this.onTap,
  });

  final DialogModel dialog;
  final VoidCallback onTap;

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd.MM').format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final firstLetter = dialog.otherUserName.isNotEmpty
        ? dialog.otherUserName[0].toUpperCase()
        : '?';

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFD9D9D9)),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFFEAF1FF),
              child: Text(
                firstLetter,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3578F6),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dialog.otherUserName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(dialog.lastMessageAt),
                        style: const TextStyle(
                          color: Color(0xFF3578F6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dialog.lastText.isEmpty
                        ? 'Сообщений пока нет'
                        : dialog.lastText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}