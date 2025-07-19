import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _username;
  bool _isLoggedIn = false;

  String? get username => _username;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _loadUser ();
  }

  Future<void> _loadUser () async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    _isLoggedIn = _username != null;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    // Hardcoded credentials: 'shanto' / '123456'
    if (username == 'shanto' && password == '123456') {
      _username = username;
      _isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      notifyListeners();
      return true;
    }
    _isLoggedIn = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String username, String password, String name) async {
    // Simulate registration logic
    if (username.isNotEmpty && password.length >= 6) {
      _username = username; // Store username
      _isLoggedIn = true; // Set logged in status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username); // Save to shared preferences
      notifyListeners();
      return true; // Simulate successful registration
    }
    return false; // Registration failed
  }

  Future<void> logout() async {
    _username = null;
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    notifyListeners();
  }

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    _isLoggedIn = _username != null;
    notifyListeners();
    return _isLoggedIn;
  }
}