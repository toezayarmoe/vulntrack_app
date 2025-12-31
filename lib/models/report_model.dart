class ReportModel {
  final int id;
  final String name;

  ReportModel({required this.id, required this.name});

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(id: json['id'], name: json['name']);
  }
}
