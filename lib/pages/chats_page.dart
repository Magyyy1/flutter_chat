import 'package:flutter/material.dart';
import 'package:flutter_chat/models/dialog_model.dart';
import 'package:flutter_chat/pages/chat_page.dart';
import 'package:flutter_chat/pages/profile_page.dart';
import 'package:flutter_chat/services/dialog_service.dart';
import 'package:flutter_chat/widgets/chat_tile.dart';
import 'package:provider/provider.dart';

//import 'package:flutter_chat/core/theme.dart';
//import 'package:flutter_chat/pages/chats_page.dart';
//import 'package:flutter_chat/pages/login_page.dart';
//import 'package:flutter_chat/pages/splash_page.dart';
import 'package:flutter_chat/services/auth_service.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final DialogService _dialogService = DialogService();

  List<DialogModel> _dialogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDialogs();
    _subscribe();
  }

  void _subscribe() {
  final auth = context.read<AuthController>();
  final userId = auth.currentUserId;
  if (userId == null) return;
  _dialogService.subscribe(userId, (dialog) {
    if (!mounted) return;

    setState(() {
      _dialogs.insert(0, dialog);
    });
  });
}
  
  Future<void> _loadDialogs() async {
    final auth = context.read<AuthController>();
    final userId = auth.currentUserId;

    if (userId == null) return;

    final dialogs = await _dialogService.getDialogs(userId);

    if (!mounted) return;

    setState(() {
      _dialogs = dialogs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сообщения'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfilePage(),
                ),
              );
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _dialogs.length,
              itemBuilder: (context, i) {
                final dialog = _dialogs[i];

                return ChatTile(
                  dialog: dialog,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ChatPage(dialog: dialog),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}