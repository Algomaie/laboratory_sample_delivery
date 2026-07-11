import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alpha/models/deliver_model.dart';

class DeliverRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'Delivers';

  /// Add a new deliver to Firestore
  Future<void> addDeliver(DeliverModel deliver, String uid) async {
    await _firestore.collection(_collection).doc(uid).set(deliver.toMap());
  }

  /// Update existing deliver in Firestore
  Future<void> updateDeliver(String uid, Map<String, dynamic> data) async {
    await _firestore.collection(_collection).doc(uid).update(data);
  }

  /// Delete deliver from Firestore
  Future<void> deleteDeliver(String uid) async {
    await _firestore.collection(_collection).doc(uid).delete();
  }

  /// Get a single deliver by ID
  Future<DeliverModel?> getDeliverById(String uid) async {
    final doc = await _firestore.collection(_collection).doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return DeliverModel.fromMap(doc.data()!);
    }
    return null;
  }

  /// Get stream of all delivers
  Stream<QuerySnapshot> getDeliversStream() {
    return _firestore.collection(_collection).snapshots();
  }

  /// Find a deliver by email
  Future<DeliverModel?> getDeliverByEmail(String email) async {
    final query = await _firestore
        .collection(_collection)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      final data = query.docs.first.data();
      data['id'] = query.docs.first.id;
      data['d_id'] = query.docs.first.id;
      return DeliverModel.fromMap(data);
    }
    return null;
  }
}
