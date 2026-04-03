import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:landmate/features/auth/services/auth_api.dart';
import 'package:landmate/features/dashboard/models/project_model.dart';
import 'package:landmate/features/dashboard/models/survey_model.dart';
import 'package:landmate/features/dashboard/projects/edit_survey_screen.dart';

class AddSurveyScreen extends StatefulWidget {
  final Project project;

  const AddSurveyScreen({super.key, required this.project});

  @override
  State<AddSurveyScreen> createState() => _AddSurveyScreenState();
}

class _AddSurveyScreenState extends State<AddSurveyScreen> {
  final _formKey = GlobalKey<FormState>();

  final _villageController = TextEditingController();
  final _surveyNoController = TextEditingController();
  final _areaController = TextEditingController();
  String? _type; // Lease / Sale

  final _leaseDeedController = TextEditingController();
  final _saleDeedController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await AuthApi.createSurvey(
        data: {
          "project_id": widget.project.id,
          "village": _villageController.text,
          "survey_no": _surveyNoController.text,
          "area": double.parse(_areaController.text),

          "acquisition_type": _type,

          if (_type == "Lease") "lease_deed_no": _leaseDeedController.text,

          if (_type == "Sale") "lease_deed_no": _saleDeedController.text,
        },
      );
      if (!mounted) return;
      Survey survey = Survey.fromJson(response.data); // 🔥 parse response
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => EditSurveyScreen(
            survey: survey, // 🔥 from response
          ),
        ),
      ); // 🔥 return success
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;

        if (e is DioException) {
          _error = e.response?.data.toString() ?? "Failed";
        } else {
          _error = "Something went wrong";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Survey")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              /// 🔹 Project Info
              Text(
                "Project: ${widget.project.name}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              /// 🔹 Village
              TextFormField(
                controller: _villageController,
                decoration: const InputDecoration(
                  labelText: "Village",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter village" : null,
              ),

              const SizedBox(height: 16),

              /// 🔹 Survey Number
              TextFormField(
                controller: _surveyNoController,
                decoration: const InputDecoration(
                  labelText: "Survey Number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter survey number" : null,
              ),

              const SizedBox(height: 16),

              /// 🔹 Area
              TextFormField(
                controller: _areaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Area (acres)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter area" : null,
              ),

              const SizedBox(height: 16),

              /// 🔹 Acquisition Type
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: const InputDecoration(
                  labelText: "Type",
                  border: OutlineInputBorder(),
                ),
                items: ["Lease", "Sale"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() => _type = value);
                },
                validator: (value) => value == null ? "Select type" : null,
              ),
              if (_type == "Lease") ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _leaseDeedController,
                  decoration: const InputDecoration(
                    labelText: "Lease Deed No",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Enter lease deed number" : null,
                ),
              ],

              if (_type == "Sale") ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _saleDeedController,
                  decoration: const InputDecoration(
                    labelText: "Sale Deed No",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Enter sale deed number" : null,
                ),
              ],
              const SizedBox(height: 20),

              /// 🔹 Error
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),

              const SizedBox(height: 10),

              /// 🔹 Submit
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
