class PatientInfoModel {
  final String name;
  final int age;
  final String? bloodType;

  const PatientInfoModel({
    required this.name,
    required this.age,
    this.bloodType,
  });

  factory PatientInfoModel.fromJson(Map<String, dynamic> json) {
    return PatientInfoModel(
      name: json['name'] as String,
      age: json['age'] as int,
      bloodType: json['blood_type'] as String?,
    );
  }
}
