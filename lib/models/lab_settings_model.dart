class LabSettingsModel {
  String? labName;
  String? labLogoUrl;

  LabSettingsModel({this.labName, this.labLogoUrl});

  Map<String, dynamic> toMap() {
    return {
      'labName': labName,
      'labLogoUrl': labLogoUrl,
    };
  }

  factory LabSettingsModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return LabSettingsModel();
    return LabSettingsModel(
      labName: map['labName'],
      labLogoUrl: map['labLogoUrl'],
    );
  }
}
