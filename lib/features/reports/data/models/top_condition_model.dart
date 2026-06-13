class TopConditionModel {
  final String name;
  final int count;

  const TopConditionModel({
    required this.name,
    required this.count,
  });

  factory TopConditionModel.fromJson(Map<String, dynamic> json) {
    return TopConditionModel(
      name: json['name'] as String,
      count: json['count'] as int,
    );
  }
}
