import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dialog_model.dart';
import '../models/message_model.dart';
import '../services/auth_service.dart';
import '../services/message_service.dart';
import '../widgets/message_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.dialog,
  });

  final DialogModel dialog;

  @override
  State<ChatPage> createState() => _ChatPageState();

  // Статический метод для быстрого перехода (можно использовать, но не обязательно)
  static Future<void> fromIds({
    required String dialogId,
    required String otherUserName,
  }) async {
    // Здесь можно реализовать навигацию, если нужно.
    // Пока заглушка, чтобы убрать предупреждение о пустом теле.
  }
}

class _ChatPageState extends State<ChatPage> {
  final MessageService _messageService = MessageService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<MessageModel> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _subscribe();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    try {
      final messages = await _messageService.getMessages(widget.dialog.id);
      if (!mounted) return;
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _subscribe() {
    _messageService.subscribe(widget.dialog.id, (message) {
      if (!mounted) return;
      setState(() {
        // Проверяем, нет ли уже такого сообщения (чтобы избежать дублей при оптимистичной отправке)
        final exists = _messages.any((m) => m.id == message.id || m.tempId == message.tempId);
        if (!exists) {
          _messages.add(message);
          _scrollToBottom();
        }
      });
    });
  }

  Future<void> _sendMessage() async {
    final auth = context.read<AuthController>();
    final currentUserId = auth.currentUserId;
    final text = _messageController.text.trim();

    if (currentUserId == null || text.isEmpty || _isSending) return;

    setState(() => _isSending = true);

    // Оптимистично показываем сообщение сразу
    final tempMessage = MessageModel(
      id: '', // или временный UUID
      tempId: DateTime.now().millisecondsSinceEpoch.toString(), // временный идентификатор
      dialogId: widget.dialog.id,
      senderId: currentUserId,
      senderName: 'Вы', // или из auth
      text: text,
      createdAt: DateTime.now(),
      isSending: true, // флаг для отображения индикатора отправки
    );

    setState(() {
      _messages.add(tempMessage);
      _messageController.clear();
    });
    _scrollToBottom();

    try {
      // Отправляем на сервер
      final sentMessage = await _messageService.sendMessage(
        dialogId: widget.dialog.id,
        senderId: currentUserId,
        text: text,
      );

      // Заменяем временное сообщение реальным (находим по tempId)
      if (!mounted) return;
      setState(() {
        final index = _messages.indexWhere((m) => m.tempId == tempMessage.tempId);
        if (index != -1) {
          _messages[index] = sentMessage;
        }
      });
    } catch (e) {
      // Ошибка отправки: помечаем сообщение как неудачное или удаляем
      if (!mounted) return;
      setState(() {
        final index = _messages.indexWhere((m) => m.tempId == tempMessage.tempId);
        if (index != -1) {
          // Например, показываем ошибку
          _messages[index] = tempMessage.copyWith(isSending: false, hasError: true);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка отправки: $e')),
      );
    } finally {
      // finally используем только для сброса флага, без return
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthController>().currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dialog.otherUserName),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return MessageBubble(
                        message: message,
                        isMine: message.senderId == currentUserId,
                      );
                    },
                  ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Сообщение...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              IconButton(
                onPressed: _isSending ? null : _sendMessage,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }
}