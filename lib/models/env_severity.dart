class EnvSeverity {
  final List<ServerEnv> data;
  final int total;

  EnvSeverity({required this.data, required this.total});

  // Factory to create a EnvPerHost from JSON
  factory EnvSeverity.fromJson(Map<String, dynamic> json) {
    return EnvSeverity(
      data: (json['data'] as List)
          .map((item) => ServerEnv.fromJson(item))
          .toList(),
      total: json['total'] ?? 0,
    );
  }

  // Method to convert the object back to JSON
  Map<String, dynamic> toJson() => {
    "data": data.map((item) => item.toJson()).toList(),
    "total": total,
  };
}

class ServerEnv {
  final int id;
  final String name;
  final int critical;
  final int high;
  final int medium;
  final int low;
  final int info;

  ServerEnv({
    required this.id,
    required this.name,
    required this.critical,
    required this.high,
    required this.medium,
    required this.low,
    required this.info,
  });

  factory ServerEnv.fromJson(Map<String, dynamic> json) {
    return ServerEnv(
      id: json['ID'] ?? 0,
      name: json['Name'] ?? '',
      critical: json['Critical'] ?? 0,
      high: json['High'] ?? 0,
      medium: json['Medium'] ?? 0,
      low: json['Low'] ?? 0,
      info: json['Info'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Name": name,
    "Critical": critical,
    "High": high,
    "Medium": medium,
    "Low": low,
    "Info": info,
  };
}
