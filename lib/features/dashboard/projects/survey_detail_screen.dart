import 'package:flutter/material.dart';
import 'package:landmate/features/dashboard/models/survey_model.dart';
import 'package:landmate/features/dashboard/projects/edit_survey_screen.dart';

class SurveyDetailScreen extends StatelessWidget {
  final Survey survey;

  const SurveyDetailScreen({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Survey ${survey.surveyNo}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            /// 🔹 Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      survey.surveyNo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text("Area: ${survey.area.toStringAsFixed(3)} acres"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 Basic Info
            _sectionTitle("Basic Info"),

            _infoTile("Village", survey.village),
            _infoTile("Type", survey.acquisitionType),

            const SizedBox(height: 16),

            /// 🔹 Conditional Details
            _sectionTitle("Details"),

            if (survey.acquisitionType == "Lease")
              _infoTile("Lease Deed No", survey.leaseDeedNo), // update later

            if (survey.acquisitionType == "Sale")
              _infoTile("Sale Deed No", survey.leaseDeedNo),

            const SizedBox(height: 16),

            /// 🔹 Status (placeholder for now)
            _sectionTitle("Status"),

            Wrap(
              spacing: 8,
              children: [
                _statusChip("Available"),
                _statusChip("No Dispute"),
                _statusChip("Docs Pending"),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 Actions
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditSurveyScreen(
                      survey: survey, // 🔥 from response
                    ),
                  ),
                );
              },
              child: const Text("Edit Survey"),
            ),

            const SizedBox(height: 10),

            OutlinedButton(
              onPressed: () {
                print("Upload documents");
              },
              child: const Text("Add Documents"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(value),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _statusChip(String label) {
    return Chip(label: Text(label));
  }
}
