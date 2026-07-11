import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MigrateOrders {
  static Future<void> runMigration() async {
    //debugPrint("🚀 بدء عملية تهيئة وترقية بيانات الطلبات...");
    final firestore = FirebaseFirestore.instance;
    final orders = await firestore.collection('orders').get();
    
    int count = 0;
    WriteBatch batch = firestore.batch();
    
    for (var doc in orders.docs) {
      final data = doc.data();
      // Only migrate orders that don't have customer_name yet
      if (!data.containsKey('customer_name') || data['customer_name'] == null) {
        String cId = data['customer_id'] ?? '';
        String dId = data['d_id'] ?? '';
        
        String cName = 'غير معروف';
        String cPhone = 'غير متوفر';
        String dName = 'غير معروف';
        String dPhone = 'غير متوفر';
        
        if (cId.isNotEmpty) {
          final cDoc = await firestore.collection('Customers').doc(cId).get();
          if (cDoc.exists) {
            cName = cDoc.data()?['dname'] ?? 'غير معروف';
            cPhone = cDoc.data()?['phone']?.toString() ?? 'غير متوفر';
          }
        }
        
        if (dId.isNotEmpty) {
          final dDoc = await firestore.collection('Delivers').doc(dId).get();
          if (dDoc.exists) {
            dName = dDoc.data()?['dname'] ?? 'غير معروف';
            dPhone = dDoc.data()?['phone']?.toString() ?? 'غير متوفر';
          }
        }
        
        batch.update(doc.reference, {
          'customer_name': cName,
          'customer_phone': cPhone,
          'deliver_name': dName,
          'deliver_phone': dPhone,
        });
        
        count++;
        // Firestore batch limits to 500 ops
        if (count % 400 == 0) {
          await batch.commit();
          batch = firestore.batch();
        }
      }
    }
    
    if (count % 400 != 0) {
      await batch.commit();
    }
    //debugPrint("✅ اكتملت الترقية بنجاح. تم تحديث $count طلب.");
  }
}
