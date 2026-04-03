import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:landmate/features/auth/services/auth_api.dart';
import 'package:landmate/features/dashboard/models/survey_model.dart';
import 'package:landmate/features/dashboard/models/project_model.dart';
import 'package:landmate/features/dashboard/projects/add_survey_screen.dart';
import 'package:landmate/features/dashboard/projects/survey_detail_screen.dart';

class SurveyListScreen extends StatefulWidget {
  final Project project;

  const SurveyListScreen({super.key, required this.project});

  @override
  State<SurveyListScreen> createState() => _SurveyListScreenState();
}

class _SurveyListScreenState extends State<SurveyListScreen> {
  bool _isLoading = true;
  String? _error;
  List<Survey> _surveys = [];

  @override
  void initState() {
    super.initState();
    _fetchSurveys();
  }

  Future<void> _fetchSurveys() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await AuthApi.getSurveys(widget.project.id);

      final data = response.data as List;

      _surveys = data.map((json) => Survey.fromJson(json)).toList();

      if (!mounted) return;

      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;

        if (e is DioException) {
          _error = "Failed (${e.response?.statusCode})";
        } else {
          _error = "Something went wrong";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchSurveys),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddSurveyScreen(project: widget.project),
            ),
          );

          if (result == true) {
            _fetchSurveys(); // 🔥 refresh list
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_surveys.isEmpty) {
      return const Center(child: Text("No surveys found"));
    }

    return RefreshIndicator(
      onRefresh: _fetchSurveys,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _surveys.length,
        itemBuilder: (context, index) {
          final survey = _surveys[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SurveyDetailScreen(survey: survey),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 Top Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          survey.surveyNo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "${survey.area.toStringAsFixed(3)} acres",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// 🔹 Village
                    Text(
                      survey.village,
                      style: TextStyle(color: Colors.grey[700]),
                    ),

                    const SizedBox(height: 8),

                    /// 🔹 Acquisition Type
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F4EA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        survey.acquisitionType,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF0F766E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
