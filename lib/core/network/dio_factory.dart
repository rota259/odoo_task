import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

abstract final class DioFactory {
  static const _timeout = Duration(seconds: 20);

  /// Cookie jar persisted on disk so the Odoo `session_id` survives restarts.
  static Future<PersistCookieJar> createCookieJar() async {
    final dir = await getApplicationSupportDirectory();
    return PersistCookieJar(
      ignoreExpires: false,
      storage: FileStorage('${dir.path}/.cookies/'),
    );
  }

  static Dio create(CookieJar jar) {
    final dio = Dio(
      BaseOptions(
        connectTimeout: _timeout,
        sendTimeout: _timeout,
        receiveTimeout: _timeout,
      ),
    );
    dio.interceptors.add(CookieManager(jar));
    return dio;
  }
}
