import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const String _keyFullName = 'user_full_name';
  static const String _keyEmail = 'user_email';

  Future<void> saveUserData(String fullName, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFullName, fullName);
    await prefs.setString(_keyEmail, email);
  }

  Future<String> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFullName) ?? 'Guest User'; // Default placeholder
  }

  Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail) ??
        'guest@example.com'; // Default placeholder
  }

  static const String _keyWishlist = 'user_wishlist';

  Future<List<String>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyWishlist) ?? [];
  }

  Future<void> toggleWishlist(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> wishlist = prefs.getStringList(_keyWishlist) ?? [];
    if (wishlist.contains(courseId)) {
      wishlist.remove(courseId);
    } else {
      wishlist.add(courseId);
    }
    await prefs.setStringList(_keyWishlist, wishlist);
  }
}
