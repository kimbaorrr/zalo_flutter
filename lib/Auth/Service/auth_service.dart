import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter_myapp/Auth/UserModel.dart';

class AuthService with ChangeNotifier {
  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  User? _userFromFirebase(auth.User? user) {
    if (user == null) return null;
    return User(user.uid, user.phoneNumber);
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();
      return _userFromFirebase(credential.user);
    } on SocketException catch (e) {
      print('no internet');
      setMessage('Không có mạng');
    } on auth.FirebaseAuthException catch (e) {
      print('Thông tin tài khoản hoặc mật khẩu không chính xác!');
      setMessage('Thông tin tài khoản hoặc mật khẩu không chính xác!');
    }
  }

  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(credential.user);
    } on auth.FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  void setMessage(message) {
    _errorMessage = message;
    notifyListeners();
  }
}
