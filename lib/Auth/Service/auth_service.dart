import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zalo/Auth/Service/constant.dart';
import '/Auth/UserModel.dart';

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
    } on SocketException {
      print('no internet');
      setMessage('Không có mạng');
    } on auth.FirebaseAuthException {
      print('Thông tin tài khoản hoặc mật khẩu không chính xác!');
      setMessage('Thông tin tài khoản hoặc mật khẩu không chính xác!');
    }
    return null;
  }

  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final auth.UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      return _userFromFirebase(credential.user);
    } on auth.FirebaseAuthException catch (e) {
      print("Error: ${e.message}");
    } catch (e) {
      print("Unexpected error: $e");
    }

    return null;
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Constants.myName = "";
    Constants.myEmail = "";
    Constants.myAvatar = "";
    return await _firebaseAuth.signOut();
  }

  void setMessage(message) {
    _errorMessage = message;
    notifyListeners();
  }
}
