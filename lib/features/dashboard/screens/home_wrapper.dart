import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:landmate/features/auth/providers/auth_provider.dart';
import 'admin_screen.dart';
import '../projects/project_screen.dart';
import 'land_screen.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user!;

    if (user["is_admin"] == true) {
      return const AdminScreen();
    } else if (user["is_staff"] == true) {
      return const ProjectScreen();
    } else {
      return const LandScreen();
    }
  }
}
