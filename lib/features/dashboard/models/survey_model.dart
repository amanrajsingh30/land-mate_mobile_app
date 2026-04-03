class Survey {
  final int id;
  final String village;
  final String surveyNo;
  final double area;
  final String acquisitionType;
  final int projectId;
  String leaseDeedNo; // nullable for non-lease surveys

  Survey({
    required this.id,
    required this.village,
    required this.surveyNo,
    required this.area,
    required this.acquisitionType,
    this.leaseDeedNo = 'null',
    required this.projectId,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json['id'] ?? 0,
      village: json['village'] ?? '',
      surveyNo: json['survey_no'] ?? '',
      area: (json['area'] ?? 0).toDouble(),
      acquisitionType: json['acquisition_type'] ?? '',
      leaseDeedNo: json['lease_deed_no'] ?? '', // nullable
      projectId: json['project_id'] ?? 0,
    );
  }
}
