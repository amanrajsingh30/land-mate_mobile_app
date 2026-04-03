import 'package:flutter/material.dart';
import 'package:landmate/app_theme.dart';
import 'package:landmate/features/auth/screens/login_screen.dart';
import 'package:landmate/features/auth/services/auth_api.dart';
import 'package:landmate/features/dashboard/screens/home_wrapper.dart';
import 'package:provider/provider.dart';
import 'features/auth/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthApi.init();

  AuthApi.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider()..checkAuth(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (auth.isLoggedIn) {
            return const HomeWrapper(); // role-based screen
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
