import 'package:flutter/material.dart';
import 'package:landmate/features/dashboard/models/project_model.dart';
import 'package:landmate/features/dashboard/projects/add_survey_screen.dart';
import 'package:landmate/features/dashboard/projects/survey_list_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(project.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Code: ${project.projectCode}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        _infoItem(Icons.location_on_outlined, project.location),
                        const SizedBox(width: 20),
                        _infoItem(
                          Icons.square_foot,
                          "${project.areaRequired} acres",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 Stats Section (future-ready)
            Row(
              children: [
                Expanded(child: _statCard("Surveys", "0")),
                const SizedBox(width: 10),
                Expanded(child: _statCard("Acquired", "0")),
                const SizedBox(width: 10),
                Expanded(child: _statCard("Pending", "0")),
              ],
            ),

            const SizedBox(height: 30),

            /// 🔹 Actions
            Text("Actions", style: Theme.of(context).textTheme.titleMedium),

            const SizedBox(height: 12),

            /// 🔹 View Surveys
            _actionTile(
              icon: Icons.list_alt,
              title: "View Surveys",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SurveyListScreen(project: project),
                  ),
                );
              },
            ),

            /// 🔹 Add Survey
            _actionTile(
              icon: Icons.add_circle_outline,
              title: "Add Survey",
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddSurveyScreen(project: project),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Info row item
  Widget _infoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }

  /// 🔹 Stat card
  Widget _statCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  /// 🔹 Action tile
  Widget _actionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
