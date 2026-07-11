import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Thin wrapper around FirebaseAuth for testability and separation of concerns.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;
  String? get uid => _auth.currentUser?.uid;

  /// Sign in with email and password via Firebase Auth.
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Register a new account via Firebase Auth.
  Future<UserCredential> register(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Create a new Firebase Auth account WITHOUT signing out the current user.
  /// Uses a secondary Firebase App instance to avoid disrupting the admin session.
  Future<String> createAccountForUser(String email, String password) async {
    FirebaseApp secondaryApp;
    try {
      secondaryApp = Firebase.app('SecondaryApp');
    } catch (e) {
      secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );
    }
    
    final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);
    
    String? uid;
    try {
      final credential = await secondaryAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      uid = credential.user!.uid;
    } on TypeError catch (_) {
      // Known Pigeon deserialization bug in firebase_auth 4.x
      // The account IS created, just the return type fails to deserialize.
      uid = secondaryAuth.currentUser?.uid;
    }
    
    if (uid == null || uid.isEmpty) {
      throw Exception('فشل إنشاء الحساب');
    }
    
    await secondaryAuth.signOut();
    return uid;
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Delete the current user's account.
  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }

  /// Change the current user's password.
  Future<void> changePassword(String currentPassword, String newPassword) async {
    final user = _auth.currentUser!;
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }
}
