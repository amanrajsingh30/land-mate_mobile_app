import 'package:flutter/material.dart';
import 'package:landmate/features/auth/services/auth_api.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:landmate/features/auth/providers/auth_provider.dart';
import 'package:landmate/features/auth/screens/set_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _isFirstTime = false;
  String? _errorMessage;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      switch (e.response?.statusCode) {
        case 400:
          return "Missing credentials";
        case 401:
          return "Invalid username or password";
        case 403:
          return "Account disabled";
        default:
          return "Server error (${e.response?.statusCode})";
      }
    } else {
      return "Network error. Check your connection.";
    }
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await AuthApi.clearSession(); // Clear cookies before login to avoid session issues
      await AuthApi.getCsrfToken();

      final response = await AuthApi.login(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      print("LOGIN RESPONSE: ${response.data}");

      // 🔹 First-time password flow
      if (response.data["must_set_password"] == true) {
        final me = await AuthApi.getMe(); // ✅ only here

        if (!mounted) return;

        final actualUsername = me.data["username"];

        setState(() {
          _isLoading = false;
          _isFirstTime = true;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SetPasswordScreen(username: actualUsername),
          ),
        );
        return;
      }

      // 🔹 Normal login
      final me = await AuthApi.getMe();

      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login Successful')));

      context.read<AuthProvider>().setUser(me.data);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;

        if (e is DioException) {
          print("ERROR STATUS: ${e.response?.statusCode}");
          print("ERROR DATA: ${e.response?.data}");
          _errorMessage = _handleError(e);
        } else {
          _errorMessage = "Something went wrong";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Top Section (Fixed Column properly)
                const SizedBox(height: 16),

                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'Login to your account',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),

                const SizedBox(height: 48),

                // 🔹 Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).nextFocus();
                        },
                        validator: _validateUsername,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        enabled:
                            !_isFirstTime, // Disable password field if first-time flow
                        controller: _passwordController,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          _handleLogin();
                        },
                        obscureText: _obscurePassword,
                        validator: _validatePassword,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 Error Message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                const SizedBox(height: 16),

                // 🔹 Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Login',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
