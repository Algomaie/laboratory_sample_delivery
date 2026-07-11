import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'orders';

  /// Add a new order
  Future<void> addOrder(Map<String, dynamic> orderData, {String? docId}) async {
    if (docId != null) {
      await _firestore.collection(_collection).doc(docId).set(orderData);
    } else {
      await _firestore.collection(_collection).add(orderData);
    }
  }

  /// Update existing order
  Future<void> updateOrder(String orderId, Map<String, dynamic> data) async {
    await _firestore.collection(_collection).doc(orderId).update(data);
  }

  /// Delete order
  Future<void> deleteOrder(String orderId) async {
    await _firestore.collection(_collection).doc(orderId).delete();
  }

  /// Get stream of all orders
  Stream<QuerySnapshot> getOrdersStream() {
    return _firestore.collection(_collection).snapshots();
  }
}
