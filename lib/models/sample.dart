class Sample {
  String m1;
  String m2;
  String m3;
  String? id;

  Sample({required this.m1, required this.m2, required this.m3, this.id});

  Map<String, dynamic> toJson() {
    return {'m1': m1, 'm2': m2, 'm3': m3, "id": id};
  }

  factory Sample.fromJson(Map<String, dynamic> json) {
    return Sample(
      m1: json['m1'],
      m2: json['m2'],
      m3: json['m3'],
      id: json['id'],
    );
  }
}
