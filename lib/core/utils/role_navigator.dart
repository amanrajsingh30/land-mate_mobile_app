import 'package:flutter/material.dart';
import '../../features/dashboard/screens/admin_screen.dart';
import '../../features/dashboard/projects/project_screen.dart';
import '../../features/dashboard/screens/land_screen.dart';

class RoleNavigator {
  static void navigate(BuildContext context, Map<String, dynamic> user) {
    Widget screen;

    if (user["is_admin"] == true) {
      screen = const AdminScreen();
    } else if (user["is_staff"] == true) {
      screen = const ProjectScreen();
    } else {
      screen = const LandScreen();
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => screen),
      (route) => false,
    );
  }
}
