import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:alpha/controller/license_controller.dart';
import 'package:alpha/widgets/custom_button.dart';
import 'package:alpha/widgets/custom_snackbar.dart';

class LicenseManagerScreen extends StatefulWidget {
  @override
  _LicenseManagerScreenState createState() => _LicenseManagerScreenState();
}

class _LicenseManagerScreenState extends State<LicenseManagerScreen> {
  final LicenseController licenseController = Get.find<LicenseController>();
  String _selectedType = 'lifetime'; // 'lifetime', 'monthly', 'yearly'
  int? _durationMonths;

  void _generate() async {
    String typeLabel = '';
    if (_selectedType == 'monthly') {
      _durationMonths = 1;
      typeLabel = 'شهرية';
    } else if (_selectedType == 'yearly') {
      _durationMonths = 12;
      typeLabel = 'سنوية';
    } else {
      _durationMonths = null;
      typeLabel = 'مدى الحياة';
    }

    String newKey = await licenseController.generateLicense(_selectedType, _durationMonths);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("تم إنشاء مفتاح بنجاح"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("نوع الرخصة: $typeLabel"),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(newKey, style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: newKey));
                showCustomSnackBar("تم نسخ المفتاح", isError: false);
                Navigator.pop(context);
              },
              child: Text("نسخ وإغلاق"),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("إدارة رخص التطبيق"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "توليد مفتاح منتج جديد",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("اختر نوع الرخصة:"),
            DropdownButton<String>(
              value: _selectedType,
              isExpanded: true,
              items: [
                DropdownMenuItem(value: 'lifetime', child: Text("مدى الحياة (Lifetime)")),
                DropdownMenuItem(value: 'yearly', child: Text("سنوية (1 Year)")),
                DropdownMenuItem(value: 'monthly', child: Text("شهرية (1 Month)")),
              ],
              onChanged: (val) {
                setState(() {
                  _selectedType = val!;
                });
              },
            ),
            SizedBox(height: 30),
            CustomButton(
              buttonText: "توليد المفتاح الآن",
              onPressed: _generate,
            ),
            SizedBox(height: 40),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue),
                        SizedBox(width: 10),
                        Text("ملاحظة هامة", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "عند توليد مفتاح وإرساله للعميل، سيتم ربط المفتاح بهاتف العميل فور تفعيله ولن يستطيع استخدامه في أي هاتف آخر.",
                      style: TextStyle(height: 1.5),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
