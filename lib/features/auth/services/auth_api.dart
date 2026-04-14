import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

// Web-only import — safe on all platforms via conditional import
import 'csrf_web.dart' if (dart.library.io) 'csrf_stub.dart' as csrf_helper;

class AuthApi {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://dev-land-mate.hindujarenewables.com",
      headers: {"Content-Type": "application/json"},
      extra: {"withCredentials": true}, // required for cookies on web
    ),
  );

  static late CookieJar _cookieJar;

  /// 🔥 INIT — call once at app startup
  static Future<void> init() async {
    if (kIsWeb) {
      _cookieJar = CookieJar();
      // Do NOT add CookieManager on web — browser handles cookies natively
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final path = "${dir.path}/cookies";
      _cookieJar = PersistCookieJar(storage: FileStorage(path));
      _dio.interceptors.add(CookieManager(_cookieJar));
    }
  }

  /// 🔹 Get CSRF token — browser cookie on web, Dio jar on mobile
  static Future<String?> _getCsrfToken() async {
    if (kIsWeb) {
      return csrf_helper.getCsrfFromBrowser();
    }

    // Mobile: read from the persistent cookie jar (correct domain)
    final cookies = await _cookieJar.loadForRequest(
      Uri.parse("https://dev-land-mate.hindujarenewables.com"),
    );
    for (final cookie in cookies) {
      if (cookie.name == "csrftoken") return cookie.value;
    }
    return null;
  }

  /// Build Options with CSRF header, skipping if token is null
  static Options _csrfOptions(String? csrf) {
    return Options(headers: {if (csrf != null) "X-CSRFToken": csrf});
  }

  // ─── Auth ────────────────────────────────────────────────────────────────

  /// Step 1: Fetch + set CSRF cookie from server
  static Future<void> getCsrfToken() async {
    await _dio.get("/api-auth/csrf/");
  }

  /// Step 2: Login
  static Future<Response> login({
    required String username,
    required String password,
  }) async {
    final csrf = await _getCsrfToken();
    return await _dio.post(
      "/api/login/",
      data: {"username": username, "password": password},
      options: _csrfOptions(csrf),
    );
  }

  /// Step 3: Get current user
  static Future<Response> getMe() async {
    return await _dio.get("/api/me/");
  }

  /// Step 4: Set password (first-time login flow)
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
      options: _csrfOptions(csrf),
    );
  }

  /// Logout — clears server session + local cookies
  static Future<void> logout() async {
    try {
      final csrf = await _getCsrfToken();
      await _dio.post(
        "/api/logout/",
        options: Options(
          headers: {if (csrf != null) "X-CSRFToken": csrf},
          validateStatus: (status) => status! < 500,
        ),
      );
    } catch (e) {
      debugPrint("Logout error: $e");
    }
    await clearSession();
  }

  /// Clear local session cookies (mobile only — browser manages its own)
  static Future<void> clearSession() async {
    if (!kIsWeb) {
      await _cookieJar.deleteAll();
    }
  }

  // ─── Projects ────────────────────────────────────────────────────────────

  static Future<Response> getProjects() async {
    return await _dio.get("/api/projects/");
  }

  // ─── Surveys ─────────────────────────────────────────────────────────────

  static Future<Response> getSurveys(int projectId) async {
    return await _dio.get(
      "/api/surveys/",
      queryParameters: {"project_id": projectId},
    );
  }

  static Future<Response> getSurveyById(int id) async {
    return await _dio.get("/api/surveys/$id/");
  }

  static Future<Response> createSurvey({
    required Map<String, dynamic> data,
  }) async {
    final csrf = await _getCsrfToken();
    return await _dio.post(
      "/api/surveys/create/",
      data: data,
      options: _csrfOptions(csrf),
    );
  }

  static Future<Response> updateSurvey({
    required Map<String, dynamic> data,
  }) async {
    final csrf = await _getCsrfToken();
    final id = data['id'];
    return await _dio.patch(
      "/api/surveys/$id/", // ← ID in URL, not just body
      data: data,
      options: _csrfOptions(csrf),
    );
  }
}
