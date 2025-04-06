import 'package:flutter/material.dart';
import '../services/api_service.dart';

// AuthProvider handles all authentication-related logic
// and notifies UI widgets when the auth state changes.
class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService(); // Instance of ApiService for API calls

  // Tracks if the user is currently authenticated
  bool _isAuthenticated = false;

  // Getter to expose authentication status
  bool get isAuthenticated => _isAuthenticated;

  // Logs the user in by calling the API and checking if a token is returned
  Future<bool> login(String email, String password) async {
    final token = await _apiService.login(email, password);
    if (token != null) {
      _isAuthenticated = true; // Set the state to authenticated
      notifyListeners(); // Notifies all listeners (like UI) to rebuild
      return true; // Login Passed
    }
    return false; // Login failed
  }

  // Registers a new user. Works similarly to login
  Future<bool> register(String email, String password) async {
    final token = await _apiService.register(email, password);
    if (token != null) {
      _isAuthenticated = true;
      notifyListeners();
      return true; // Registration Passed
    }
    return false; // Registration failed
  }

  // Logs out the user by calling the logout API and updating the state
  Future<void> logout() async {
    await _apiService.logout();
    _isAuthenticated = false;
    notifyListeners(); // Update UI to reflect logout
  }

  // Checks if the user is already logged in by verifying token existence
  Future<void> checkAuth() async {
    final token = await _apiService.getToken();
    _isAuthenticated = token != null;
    notifyListeners(); // Inform listeners of the current auth state
  }
}