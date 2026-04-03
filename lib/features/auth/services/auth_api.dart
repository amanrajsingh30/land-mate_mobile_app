import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class AuthApi {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://land-mate.hindujarenewables.com",
      headers: {"Content-Type": "application/json"},
    ),
  );

  static late CookieJar _cookieJar;

  /// 🔥 INIT (handles web + mobile)
  static Future<void> init() async {
    if (kIsWeb) {
      _cookieJar = CookieJar(); // web uses browser cookies anyway
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final path = "${dir.path}/cookies";

      _cookieJar = PersistCookieJar(storage: FileStorage(path));
    }

    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  /// 🔹 ALWAYS GET CSRF FROM COOKIE (SOURCE OF TRUTH)
  static Future<String?> _getCsrfToken() async {
    final cookies = await _cookieJar.loadForRequest(
      Uri.parse("https://land-mate.hindujarenewables.com"),
    );

    for (var cookie in cookies) {
      if (cookie.name == "csrftoken") {
        return cookie.value;
      }
    }
    return null;
  }

  /// 🔹 Step 1: Initialize CSRF cookie
  static Future<void> getCsrfToken() async {
    await _dio.get("/api-auth/csrf/");
  }

  /// 🔹 Step 2: Login
  static Future<Response> login({
    required String username,
    required String password,
  }) async {
    final csrf = await _getCsrfToken();

    return await _dio.post(
      "/api/login/",
      data: {"username": username, "password": password},
      options: Options(headers: {"X-CSRFToken": ?csrf}),
    );
  }

  /// 🔹 Step 3: Get current user
  static Future<Response> getMe() async {
    return await _dio.get("/api/me/");
  }

  /// 🔹 Step 4: Set Password
  static Future<Response> setPassword({
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    final csrf = await _getCsrfToken();

    return await _dio.post(
      "/api/set-password/",
      data: {
        "username": username,
        "password": password,
        "confirm_password": confirmPassword,
      },
      options: Options(headers: {"X-CSRFToken": ?csrf}),
    );
  }

  /// 🔹 Logout
  static Future<void> logout() async {
    try {
      final csrf = await _getCsrfToken();

      await _dio.post(
        "/api/logout/",
        options: Options(
          headers: {"X-CSRFToken": ?csrf},
          validateStatus: (status) => status! < 500, // prevent crash on 403
        ),
      );
    } catch (e) {
      print("Logout error: $e");
    }

    // 🔥 Always clear local session
    await _cookieJar.deleteAll();
  }

  /// 🔹 Clear session manually
  static Future<void> clearSession() async {
    await _cookieJar.deleteAll();
  }

  static Future<Response> getProjects() async {
    return await _dio.get("/api/projects/");
  }

  static Future<Response> getSurveys(int projectId) async {
    return await _dio.get(
      "/api/surveys/",
      queryParameters: {"project_id": projectId},
    );
  }

  static Future<Response> createSurvey({
    required Map<String, dynamic> data,
  }) async {
    final csrf = await _getCsrfToken();

    return await _dio.post(
      "/api/surveys/create/",
      data: data,
      options: Options(headers: {"X-CSRFToken": ?csrf}),
    );
  }

  static Future<Response> getSurveyById(int id) async {
    return await _dio.get("/api/surveys/$id/");
  }

  static Future<Response> updateSurvey({
    required Map<String, dynamic> data,
  }) async {
    final csrf = await _getCsrfToken();

    return await _dio.patch(
      "/api/surveys/",
      data: data,
      options: Options(headers: {if (csrf != null) "X-CSRFToken": csrf}),
    );
  }
}
