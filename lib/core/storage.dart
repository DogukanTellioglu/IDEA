import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _emailKey = 'user_email';
  static const _passwordKey = 'user_password';
  static const _usernameKey = 'user_name';
  static const _avatarKey = 'user_avatar';

  /// Kullanıcı bilgilerini kaydeder
  static Future<void> saveUser({
    required String email,
    required String password,
    required String username,
    required String avatarUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_passwordKey, password);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_avatarKey, avatarUrl);
  }

  /// Kullanıcı bilgilerini getirir
  static Future<Map<String, String>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_emailKey);
    final password = prefs.getString(_passwordKey);
    final username = prefs.getString(_usernameKey);
    final avatar = prefs.getString(_avatarKey);

    if (email != null &&
        password != null &&
        username != null &&
        avatar != null) {
      return {
        'email': email,
        'password': password,
        'username': username,
        'avatar': avatar,
      };
    }
    return null;
  }

  /// Oturumu siler
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    await prefs.remove(_passwordKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_avatarKey);
  }

  /// Oturum açık mı?
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_emailKey);
  }
}
