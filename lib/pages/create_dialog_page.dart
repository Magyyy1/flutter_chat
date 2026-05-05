import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/dialog_service.dart';
import '../services/pocketbase_service.dart';
import 'chat_page.dart';

class CreateDialogPage extends StatefulWidget {
  const CreateDialogPage({super.key});

  @override
  State<CreateDialogPage> createState() => _CreateDialogPageState();
}

class _CreateDialogPageState extends State<CreateDialogPage> {
  final TextEditingController _searchController = TextEditingController();
  final DialogService _dialogService = DialogService();
  List<RecordModel> _users = [];
  bool _isSearching = false;

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _users = []);
      return;
    }
    setState(() => _isSearching = true);
    try {
      final pb = PocketBaseService.instance.client;
      final result = await pb.collection('users').getList(
        filter: 'name ~ "$query"',
        perPage: 20,
      );
      final currentUserId = pb.authStore.record?.id;
      setState(() {
        _users = result.items.where((u) => u.id != currentUserId).toList();
      });
    } finally {
      setState(() => _isSearching = false);
    }
  }

  Future<void> _onUserTap(RecordModel otherUser) async {
    final auth = context.read<AuthController>();
    final currentUserId = auth.currentUserId;
    if (currentUserId == null) return;

    final dialog = await _dialogService.findOrCreateDialog(currentUserId, otherUser.id);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ChatPage(dialog: dialog)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Новый диалог')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск пользователей...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: _isSearching
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (_, i) {
                      final user = _users[i];
                      final name = user.getStringValue('name');
                      return ListTile(
                        leading: CircleAvatar(child: Text(name[0])),
                        title: Text(name),
                        onTap: () => _onUserTap(user),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}