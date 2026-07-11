import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alpha/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  /// Add a new admin/user to Firestore
  Future<void> addUser(UserModel user, String uid) async {
    await _firestore.collection(_collection).doc(uid).set(user.toMap());
  }

  /// Update existing user in Firestore
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection(_collection).doc(uid).update(data);
  }

  /// Delete user from Firestore
  Future<void> deleteUser(String uid) async {
    await _firestore.collection(_collection).doc(uid).delete();
  }

  /// Get a single user by ID
  Future<UserModel?> getUserById(String uid) async {
    final doc = await _firestore.collection(_collection).doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  /// Get stream of all users
  Stream<QuerySnapshot> getUsersStream() {
    return _firestore.collection(_collection).snapshots();
  }

  /// Find a user by email
  Future<UserModel?> getUserByEmail(String email) async {
    final query = await _firestore
        .collection(_collection)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      final data = query.docs.first.data();
      data['id'] = query.docs.first.id;
      return UserModel.fromMap(data);
    }
    return null;
  }
}
