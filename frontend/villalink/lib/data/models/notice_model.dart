class Notice {
  final int id;
  final String title;
  final String description;
  final String createdByName;
  final DateTime createdAt;

  Notice({
    required this.id,
    required this.title,
    required this.description,
    required this.createdByName,
    required this.createdAt,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdByName: json['created_by_name'] ?? 'Unknown',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}