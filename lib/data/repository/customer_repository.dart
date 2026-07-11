import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alpha/models/customer_model.dart'; // Will be updated to customer_model.dart later

class CustomerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'Customers';

  /// Add a new customer to Firestore
  Future<void> addCustomer(CustomerModel customer, String uid) async {
    await _firestore.collection(_collection).doc(uid).set(customer.toMap());
  }

  /// Update existing customer in Firestore
  Future<void> updateCustomer(String uid, Map<String, dynamic> data) async {
    await _firestore.collection(_collection).doc(uid).update(data);
  }

  /// Delete customer from Firestore
  Future<void> deleteCustomer(String uid) async {
    await _firestore.collection(_collection).doc(uid).delete();
  }

  /// Get a single customer by ID
  Future<CustomerModel?> getCustomerById(String uid) async {
    final doc = await _firestore.collection(_collection).doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return CustomerModel.fromMap(doc.data()!);
    }
    return null;
  }

  /// Get stream of all customers
  Stream<QuerySnapshot> getCustomersStream() {
    return _firestore.collection(_collection).snapshots();
  }

  /// Find a customer by email
  Future<CustomerModel?> getCustomerByEmail(String email) async {
    final query = await _firestore
        .collection(_collection)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      final data = query.docs.first.data();
      data['id'] = query.docs.first.id;
      data['customer_id'] = query.docs.first.id;
      return CustomerModel.fromMap(data);
    }
    return null;
  }
}
