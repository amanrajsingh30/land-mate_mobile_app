class Project {
  final int id;
  final String name;
  final String projectCode;
  final String location;
  final double areaRequired;

  Project({
    required this.id,
    required this.name,
    required this.projectCode,
    required this.location,
    required this.areaRequired,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      projectCode: json['project_code'] ?? '',
      location: json['location'] ?? '',
      areaRequired: (json['area_required'] ?? 0).toDouble(),
    );
  }
}
