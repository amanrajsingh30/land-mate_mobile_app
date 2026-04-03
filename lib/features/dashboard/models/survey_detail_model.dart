import 'package:landmate/features/dashboard/models/survey_model.dart';

class SurveyDetail {
  final int id;
  final int projectId;

  // Core
  final String village;
  final String surveyNo;
  final double area;
  final String acquisitionType;

  // Location
  final String? taluka;
  final String? district;
  final String? partyName;
  final String? registryNo;
  final String? registryDate;

  // Deed / Lease
  final String? deedDateFrom;
  final String? deedDateTo;
  final String? leaseDeedNo;
  final String? leaseType;
  final int? leaseYears;
  final String? refRegistryNo;
  final String? registeredCompanyName;

  // Area / NA
  final double? sqMeterArea;
  final String? naStatus;
  final String? naDate;
  final double? naAcre;
  final bool? isNonAgricultural;

  // Status (ALL)
  final bool statusDdUploaded;
  final bool statusTsrReceived;
  final bool statusClarificationReq;
  final bool statusPaperPubCompleted;
  final bool statusObjectionsReceived;
  final bool statusResponseSubmitted;
  final bool statusKycReceived;
  final bool statusDraftDeedReceived;
  final bool statusDeedSentFinalization;
  final bool statusDeedFinalized;
  final bool statusDeedExecuted;
  final bool statusRegisteredDeedUploaded;

  // Sub-lease
  final String? subLeaseRegistryNo;
  final double? subLeaseAcre;
  final String? subLeaseRegistryDate;
  final String? subLeaseDateFrom;
  final String? subLeaseDateTo;
  final String? subLeaseSpv;

  SurveyDetail({
    required this.id,
    required this.projectId,
    required this.village,
    required this.surveyNo,
    required this.area,
    required this.acquisitionType,

    this.taluka,
    this.district,
    this.partyName,
    this.registryNo,
    this.registryDate,

    this.deedDateFrom,
    this.deedDateTo,
    this.leaseDeedNo,
    this.leaseType,
    this.leaseYears,
    this.refRegistryNo,
    this.registeredCompanyName,

    this.sqMeterArea,
    this.naStatus,
    this.naDate,
    this.naAcre,
    this.isNonAgricultural,

    this.statusDdUploaded = false,
    this.statusTsrReceived = false,
    this.statusClarificationReq = false,
    this.statusPaperPubCompleted = false,
    this.statusObjectionsReceived = false,
    this.statusResponseSubmitted = false,
    this.statusKycReceived = false,
    this.statusDraftDeedReceived = false,
    this.statusDeedSentFinalization = false,
    this.statusDeedFinalized = false,
    this.statusDeedExecuted = false,
    this.statusRegisteredDeedUploaded = false,

    this.subLeaseRegistryNo,
    this.subLeaseAcre,
    this.subLeaseRegistryDate,
    this.subLeaseDateFrom,
    this.subLeaseDateTo,
    this.subLeaseSpv,
  });

  factory SurveyDetail.fromJson(Map<String, dynamic> json) {
    return SurveyDetail(
      id: json['id'],
      projectId: json['project'],

      village: json['village'] ?? '',
      surveyNo: json['survey_no'] ?? '',
      area: (json['area'] ?? 0).toDouble(),
      acquisitionType: json['acquisition_type'] ?? '',

      taluka: json['taluka'],
      district: json['district'],
      partyName: json['party_name'],
      registryNo: json['registry_no'],
      registryDate: json['registry_date'],

      deedDateFrom: json['deed_date_from'],
      deedDateTo: json['deed_date_to'],
      leaseDeedNo: json['lease_deed_no'],
      leaseType: json['lease_type'],
      leaseYears: json['lease_years'],
      refRegistryNo: json['ref_registry_no'],
      registeredCompanyName: json['registered_company_name'],

      sqMeterArea: (json['sq_meter_area'] ?? 0).toDouble(),
      naStatus: json['na_status'],
      naDate: json['na_date'],
      naAcre: (json['na_acre'] ?? 0).toDouble(),
      isNonAgricultural: json['is_non_agricultural'],

      statusDdUploaded: json['status_dd_uploaded'] ?? false,
      statusTsrReceived: json['status_tsr_received'] ?? false,
      statusClarificationReq: json['status_clarification_req'] ?? false,
      statusPaperPubCompleted: json['status_paper_pub_completed'] ?? false,
      statusObjectionsReceived: json['status_objections_received'] ?? false,
      statusResponseSubmitted: json['status_response_submitted'] ?? false,
      statusKycReceived: json['status_kyc_received'] ?? false,
      statusDraftDeedReceived: json['status_draft_deed_received'] ?? false,
      statusDeedSentFinalization:
          json['status_deed_sent_finalization'] ?? false,
      statusDeedFinalized: json['status_deed_finalized'] ?? false,
      statusDeedExecuted: json['status_deed_executed'] ?? false,
      statusRegisteredDeedUploaded:
          json['status_registered_deed_uploaded'] ?? false,

      subLeaseRegistryNo: json['sub_lease_registry_no'],
      subLeaseAcre: (json['sub_lease_acre'] ?? 0).toDouble(),
      subLeaseRegistryDate: json['sub_lease_registry_date'],
      subLeaseDateFrom: json['sub_lease_date_from'],
      subLeaseDateTo: json['sub_lease_date_to'],
      subLeaseSpv: json['sub_lease_spv'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "project_id": projectId,
      "village": village,
      "survey_no": surveyNo,
      "area": area,
      "acquisition_type": acquisitionType,

      "taluka": taluka,
      "district": district,
      "party_name": partyName,
      "registry_no": registryNo,
      "registry_date": registryDate,

      "deed_date_from": deedDateFrom,
      "deed_date_to": deedDateTo,
      "lease_deed_no": leaseDeedNo,
      "lease_type": leaseType,
      "lease_years": leaseYears,
      "ref_registry_no": refRegistryNo,
      "registered_company_name": registeredCompanyName,

      "sq_meter_area": sqMeterArea,
      "na_status": naStatus,
      "na_date": naDate,
      "na_acre": naAcre,
      "is_non_agricultural": isNonAgricultural,

      "status_dd_uploaded": statusDdUploaded,
      "status_tsr_received": statusTsrReceived,
      "status_clarification_req": statusClarificationReq,
      "status_paper_pub_completed": statusPaperPubCompleted,
      "status_objections_received": statusObjectionsReceived,
      "status_response_submitted": statusResponseSubmitted,
      "status_kyc_received": statusKycReceived,
      "status_draft_deed_received": statusDraftDeedReceived,
      "status_deed_sent_finalization": statusDeedSentFinalization,
      "status_deed_finalized": statusDeedFinalized,
      "status_deed_executed": statusDeedExecuted,
      "status_registered_deed_uploaded": statusRegisteredDeedUploaded,

      "sub_lease_registry_no": subLeaseRegistryNo,
      "sub_lease_acre": subLeaseAcre,
      "sub_lease_registry_date": subLeaseRegistryDate,
      "sub_lease_date_from": subLeaseDateFrom,
      "sub_lease_date_to": subLeaseDateTo,
      "sub_lease_spv": subLeaseSpv,
    };
  }

  factory SurveyDetail.fromSurvey(Survey s) {
    return SurveyDetail(
      id: s.id,
      projectId: s.projectId, // you can pass separately if needed
      village: s.village,
      surveyNo: s.surveyNo,
      area: s.area,
      acquisitionType: s.acquisitionType,

      leaseDeedNo: s.leaseDeedNo,

      // rest empty
      taluka: null,
      district: null,
      partyName: null,
      registryNo: null,
      registryDate: null,

      leaseType: null,
      leaseYears: null,

      sqMeterArea: null,
      naDate: null,
      naAcre: null,

      statusDdUploaded: false,
      statusTsrReceived: false,
      statusKycReceived: false,
      statusDeedExecuted: false,
      statusDeedFinalized: false,

      subLeaseRegistryNo: null,
      subLeaseAcre: null,
    );
  }
}
