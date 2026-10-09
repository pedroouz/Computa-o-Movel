import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String key = 'last_page';

  Future<void> saveLastPage(String page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, page);
  }

  Future<String> loadLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? 'Página A';
  }
}