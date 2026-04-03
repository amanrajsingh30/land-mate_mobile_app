import 'package:flutter/material.dart';
import 'package:landmate/features/auth/services/auth_api.dart';
import 'package:landmate/features/dashboard/models/survey_detail_model.dart';
import 'package:landmate/features/dashboard/models/survey_model.dart';

class EditSurveyScreen extends StatefulWidget {
  final Survey survey;

  const EditSurveyScreen({super.key, required this.survey});

  @override
  State<EditSurveyScreen> createState() => _EditSurveyScreenState();
}

class _EditSurveyScreenState extends State<EditSurveyScreen> {
  late SurveyDetail _surveyDetail;

  /// 🔹 Controllers
  final _village = TextEditingController();
  final _surveyNo = TextEditingController();
  final _area = TextEditingController();

  final _taluka = TextEditingController();
  final _district = TextEditingController();
  final _party = TextEditingController();
  final _registryNo = TextEditingController();
  final _registryDate = TextEditingController();

  final _deedFrom = TextEditingController();
  final _deedTo = TextEditingController();
  final _leaseDeedNo = TextEditingController();
  final _leaseType = TextEditingController();
  final _leaseYears = TextEditingController();
  final _refRegistry = TextEditingController();
  final _company = TextEditingController();

  final _sqMeter = TextEditingController();
  final _naStatus = TextEditingController();
  final _naDate = TextEditingController();
  final _naAcre = TextEditingController();

  final _subLeaseRegistryNo = TextEditingController();
  final _subLeaseAcre = TextEditingController();
  final _subLeaseRegistryDate = TextEditingController();
  final _subLeaseFrom = TextEditingController();
  final _subLeaseTo = TextEditingController();
  final _subLeaseSpv = TextEditingController();

  String? _type;

  /// 🔹 Status Toggles
  bool _dd = false;
  bool _tsr = false;
  bool _clarification = false;
  bool _paperPub = false;
  bool _objection = false;
  bool _response = false;
  bool _kyc = false;
  bool _draft = false;
  bool _sentFinal = false;
  bool _finalized = false;
  bool _executed = false;
  bool _registered = false;

  bool _isNonAgri = false;

  @override
  void initState() {
    super.initState();

    _surveyDetail = SurveyDetail.fromSurvey(widget.survey);

    /// Prefill
    _village.text = _surveyDetail.village;
    _surveyNo.text = _surveyDetail.surveyNo;
    _area.text = _surveyDetail.area.toString();

    _type = _surveyDetail.acquisitionType;

    _leaseDeedNo.text = _surveyDetail.leaseDeedNo ?? '';
  }

  Future<void> _update() async {
    final data = {
      "id": _surveyDetail.id,
      "project_id": _surveyDetail.projectId,

      "village": _village.text,
      "survey_no": _surveyNo.text,
      "area": double.tryParse(_area.text) ?? 0,
      "acquisition_type": _type,

      "taluka": _taluka.text,
      "district": _district.text,
      "party_name": _party.text,
      "registry_no": _registryNo.text,
      "registry_date": _registryDate.text,

      "deed_date_from": _deedFrom.text,
      "deed_date_to": _deedTo.text,
      "lease_deed_no": _leaseDeedNo.text,
      "lease_type": _leaseType.text,
      "lease_years": int.tryParse(_leaseYears.text),
      "ref_registry_no": _refRegistry.text,
      "registered_company_name": _company.text,

      "sq_meter_area": double.tryParse(_sqMeter.text),
      "na_status": _naStatus.text,
      "na_date": _naDate.text,
      "na_acre": double.tryParse(_naAcre.text),
      "is_non_agricultural": _isNonAgri,

      "status_dd_uploaded": _dd,
      "status_tsr_received": _tsr,
      "status_clarification_req": _clarification,
      "status_paper_pub_completed": _paperPub,
      "status_objections_received": _objection,
      "status_response_submitted": _response,
      "status_kyc_received": _kyc,
      "status_draft_deed_received": _draft,
      "status_deed_sent_finalization": _sentFinal,
      "status_deed_finalized": _finalized,
      "status_deed_executed": _executed,
      "status_registered_deed_uploaded": _registered,

      "sub_lease_registry_no": _subLeaseRegistryNo.text,
      "sub_lease_acre": double.tryParse(_subLeaseAcre.text),
      "sub_lease_registry_date": _subLeaseRegistryDate.text,
      "sub_lease_date_from": _subLeaseFrom.text,
      "sub_lease_date_to": _subLeaseTo.text,
      "sub_lease_spv": _subLeaseSpv.text,
    };

    await AuthApi.updateSurvey(data: data);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Survey Updated")));

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Survey")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _tile("Basic Info", [
            _input(_village, "Village"),
            _input(_surveyNo, "Survey No"),
            _input(_area, "Area"),
            _dropdown(),
          ]),

          _tile("Location & Party", [
            _input(_taluka, "Taluka"),
            _input(_district, "District"),
            _input(_party, "Party Name"),
            _input(_registryNo, "Registry No"),
            _input(_registryDate, "Registry Date"),
          ]),

          _tile("Deed / Lease", [
            _input(_deedFrom, "Deed Date From"),
            _input(_deedTo, "Deed Date To"),
            _input(_leaseDeedNo, "Lease Deed No"),
            _input(_leaseType, "Lease Type"),
            _input(_leaseYears, "Lease Years"),
            _input(_refRegistry, "Ref Registry No"),
            _input(_company, "Registered Company Name"),
          ]),

          _tile("Area & NA", [
            _input(_sqMeter, "Sq Meter Area"),
            _input(_naStatus, "NA Status"),
            _input(_naDate, "NA Date"),
            _input(_naAcre, "NA Acre"),
            _switch(
              "Non Agricultural",
              _isNonAgri,
              (v) => setState(() => _isNonAgri = v),
            ),
          ]),

          _tile("Status", [
            _switch("DD Uploaded", _dd, (v) => setState(() => _dd = v)),
            _switch("TSR Received", _tsr, (v) => setState(() => _tsr = v)),
            _switch(
              "Clarification Req",
              _clarification,
              (v) => setState(() => _clarification = v),
            ),
            _switch(
              "Paper Published",
              _paperPub,
              (v) => setState(() => _paperPub = v),
            ),
            _switch(
              "Objections Received",
              _objection,
              (v) => setState(() => _objection = v),
            ),
            _switch(
              "Response Submitted",
              _response,
              (v) => setState(() => _response = v),
            ),
            _switch("KYC Received", _kyc, (v) => setState(() => _kyc = v)),
            _switch(
              "Draft Deed Received",
              _draft,
              (v) => setState(() => _draft = v),
            ),
            _switch(
              "Sent for Finalization",
              _sentFinal,
              (v) => setState(() => _sentFinal = v),
            ),
            _switch(
              "Finalized",
              _finalized,
              (v) => setState(() => _finalized = v),
            ),
            _switch(
              "Executed",
              _executed,
              (v) => setState(() => _executed = v),
            ),
            _switch(
              "Registered Uploaded",
              _registered,
              (v) => setState(() => _registered = v),
            ),
          ]),

          _tile("Sub Lease", [
            _input(_subLeaseRegistryNo, "Registry No"),
            _input(_subLeaseAcre, "Acre"),
            _input(_subLeaseRegistryDate, "Registry Date"),
            _input(_subLeaseFrom, "Date From"),
            _input(_subLeaseTo, "Date To"),
            _input(_subLeaseSpv, "SPV"),
          ]),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _update,
            child: const Text("Update Survey"),
          ),
        ],
      ),
    );
  }

  /// 🔧 Helpers

  Widget _tile(String title, List<Widget> children) {
    return ExpansionTile(
      title: Text(title),
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _input(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _dropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _type,
      items: [
        "Lease",
        "Sale",
      ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (v) => setState(() => _type = v),
      decoration: const InputDecoration(
        labelText: "Acquisition Type",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _switch(String title, bool val, Function(bool) onChanged) {
    return SwitchListTile(title: Text(title), value: val, onChanged: onChanged);
  }
}
