// Used on web only — reads csrftoken from the browser's cookie store
// ignore: avoid_web_libraries_in_flutter

import 'package:web/web.dart' as web;

String? getCsrfFromBrowser() {
  final cookies = web.document.cookie;
  for (final part in cookies.split(';')) {
    final kv = part.trim().split('=');
    if (kv.length == 2 && kv[0].trim() == 'csrftoken') {
      return Uri.decodeComponent(kv[1].trim());
    }
  }
  return null;
}
