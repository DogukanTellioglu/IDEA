import '../models/user.dart';
import 'storage.dart';

class Session {
  static User? currentUser;

  /// Oturumu başlatır ve kullanıcıyı belleğe kaydeder
  static Future<void> login(User user) async {
    currentUser = user;
    await StorageService.saveUser(
      email: user.email,
      password: user.password,
      username: user.name,
      avatarUrl: user.avatarUrl,
    );
  }

  /// Oturumu sonlandırır
  static Future<void> logout() async {
    currentUser = null;
    await StorageService.clearUser();
  }

  /// Oturum açık mı?
  static Future<bool> isLoggedIn() async {
    return await StorageService.isLoggedIn();
  }

  /// Uygulama başlatıldığında kullanıcıyı geri yükler
  static Future<void> restoreSession() async {
    final data = await StorageService.getUser();
    if (data != null) {
      currentUser = User(
        name: data['username']!,
        email: data['email']!,
        password: data['password']!,
        avatarUrl: data['avatar']!,
      );
    }
  }
}
