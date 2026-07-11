import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var labName = "Alpha".obs;
  var labLogoUrl = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  void fetchSettings() {
    _firestore
        .collection('Settings')
        .doc('Global')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        labName.value = data['labName'] ?? "Alpha";
        labLogoUrl.value = data['labLogoUrl'] ?? "";
      }
    });
  }

  Future<void> updateSettings(String name, String? logoUrl) async {
    Map<String, dynamic> updateData = {
      'labName': name,
    };
    if (logoUrl != null && logoUrl.isNotEmpty) {
      updateData['labLogoUrl'] = logoUrl;
    }

    await _firestore
        .collection('Settings')
        .doc('Global')
        .set(updateData, SetOptions(merge: true));
  }
}
