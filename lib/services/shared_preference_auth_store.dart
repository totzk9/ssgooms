import 'package:nhost_sdk/nhost_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An Nhost [AuthStore] implementation backed by the `shared_preferences`
/// plugin, so authentication information is retained between runs of the
/// application.
class SharedPreferencesAuthStore implements AuthStore {
  @override
  Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  Future<void> removeItem(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
