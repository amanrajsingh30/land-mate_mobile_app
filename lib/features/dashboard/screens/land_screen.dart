import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:landmate/features/auth/services/auth_api.dart';
import 'package:landmate/features/dashboard/models/project_model.dart';
import 'package:landmate/features/dashboard/projects/project_detail_screen.dart';

class LandScreen extends StatefulWidget {
  const LandScreen({super.key});

  @override
  State<LandScreen> createState() => _LandScreenState();
}

class _LandScreenState extends State<LandScreen> {
  bool _isLoading = true;
  String? _error;

  List<Project> _projects = [];
  List<Project> _filteredProjects = [];

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await AuthApi.getProjects();

      final data = response.data as List;

      _projects = data.map((json) => Project.fromJson(json)).toList();
      _filteredProjects = _projects;

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;

        if (e is DioException) {
          _error = "Failed to load projects (${e.response?.statusCode})";
        } else {
          _error = "Something went wrong";
        }
      });
    }
  }

  void _onSearch(String query) {
    setState(() {
      _filteredProjects = _projects.where((p) {
        return p.name.toLowerCase().contains(query.toLowerCase()) ||
            p.projectCode.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Projects"),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ProjectSearchDelegate(_projects, _onSearch),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _fetchProjects,
            ),
          ],
        ),
        drawer: _buildDrawer(),
        body: _buildBody(),
      ),
    );
  }

  /// 🔹 Drawer
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF0F766E)),
            duration: Duration(
              milliseconds: int.fromEnvironment(
                "animation_duration",
                defaultValue: 300,
              ),
            ),
            curve: Curves.easeInOut,
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 10),
                  Image(
                    image: AssetImage("assets/images/HREPL-Logo.png"),
                    height: 40,

                    fit: BoxFit.fill,
                    color: Colors.white,
                  ),
                  SizedBox(height: 6),

                  // Text(
                  //   "Hinduja Renewables",
                  //   style: TextStyle(color: Colors.white, fontSize: 18),
                  // ),
                  SizedBox(height: 6),
                  Text("Land Mate", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              Navigator.pop(context);

              await AuthApi.logout();

              if (!mounted) return;

              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }

  /// 🔹 Body
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _fetchProjects,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (_filteredProjects.isEmpty) {
      return const Center(child: Text("No projects found"));
    }

    return RefreshIndicator(
      onRefresh: _fetchProjects,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredProjects.length,
        itemBuilder: (context, index) {
          final project = _filteredProjects[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProjectDetailScreen(project: project),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 Name + Arrow
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            project.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Code: ${project.projectCode}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),

                    const SizedBox(height: 14),

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

                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 8,
                      children: [
                        _statusChip("Active"),
                        _statusChip("Surveys Pending"),
                      ],
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

/// 🔹 Search Delegate
class ProjectSearchDelegate extends SearchDelegate {
  final List<Project> projects;
  final Function(String) onSearch;

  ProjectSearchDelegate(this.projects, this.onSearch);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch('');
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    close(context, null);
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = projects.where((p) {
      return p.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final project = results[index];

        return ListTile(
          title: Text(project.name),
          subtitle: Text(project.projectCode),
          onTap: () {
            query = project.name;
            onSearch(query);
            close(context, null);
          },
        );
      },
    );
  }
}

/// 🔹 Helpers
Widget _infoItem(IconData icon, String text) {
  return Row(
    children: [
      Icon(icon, size: 16, color: Colors.grey[600]),
      const SizedBox(width: 6),
      Text(text, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
    ],
  );
}

Widget _statusChip(String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFE6F4EA),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xFF0F766E),
      ),
    ),
  );
}
