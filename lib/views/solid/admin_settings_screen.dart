import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:alpha/controller/settings_controller.dart';
import 'package:alpha/widgets/custom_button.dart';
import 'package:alpha/widgets/custom_snackbar.dart';

class AdminSettingsScreen extends StatefulWidget {
  @override
  _AdminSettingsScreenState createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final SettingsController settingsController = Get.find<SettingsController>();
  final TextEditingController _nameController = TextEditingController();
  
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = settingsController.labName.value;
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveSettings() async {
    if (_nameController.text.trim().isEmpty) {
      showCustomSnackBar("الرجاء إدخال اسم المختبر");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String? logoUrl;

    try {
      if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('lab_logos')
            .child('logo_${DateTime.now().millisecondsSinceEpoch}.jpg');
        
        final uploadTask = await storageRef.putFile(_imageFile!);
        logoUrl = await uploadTask.ref.getDownloadURL();
      }

      await settingsController.updateSettings(_nameController.text.trim(), logoUrl);
      showCustomSnackBar("تم حفظ الإعدادات بنجاح", isError: false);
      Get.back();
    } catch (e) {
      showCustomSnackBar("حدث خطأ أثناء الحفظ: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("إعدادات هوية المختبر"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                ),
                child: ClipOval(
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : Obx(() {
                          if (settingsController.labLogoUrl.value.isNotEmpty) {
                            return Image.network(settingsController.labLogoUrl.value, fit: BoxFit.cover);
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                                Text("اختر شعاراً", style: TextStyle(color: Colors.grey)),
                              ],
                            );
                          }
                        }),
                ),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "اسم المختبر",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 40),
            _isLoading
                ? CircularProgressIndicator()
                : CustomButton(
                    buttonText: "حفظ الإعدادات",
                    onPressed: _saveSettings,
                  ),
          ],
        ),
      ),
    );
  }
}
