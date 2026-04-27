import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

import 'pocketbase_service.dart';

class AuthController extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.client;

  bool _isInitialized = false;
  bool _isLoading = false;

  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;

  RecordModel? get currentUser {
    final model = _pb.authStore.model;
    if (model is RecordModel) return model;
    return null;
  }

  bool get isAuthenticated =>
    _pb.authStore.isValid && currentUser != null;

  String? get currentUserId => currentUser?.id;

  Future<void> initialize() async {
    try {
      if (_pb.authStore.isValid) {
        await _pb.collection('users').authRefresh();
      }
    } catch (_) {
      _pb.authStore.clear();
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _pb.collection('users')
          .authWithPassword(email, password);

      return null;
    } on ClientException catch (e) {
      return e.response['message'] ?? 'Ошибка входа';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _pb.collection('users').create(
        body: {
          'name': name,
          'email': email,
          'password': password,
          'passwordConfirm': passwordConfirm,
        },
      );

      await _pb.collection('users')
          .authWithPassword(email, password);

      return null;
    } on ClientException catch (e) {
      return e.response['message'] ?? 'Ошибка регистрации';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _pb.authStore.clear();
    notifyListeners();
  }
}