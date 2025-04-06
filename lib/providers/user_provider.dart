import 'package:flutter/cupertino.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

// UserProvider manages all user-related data and operations.
// It also notifies the UI when there's any change in data.
class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService(); // Handles API calls
  List<UserModel> _users = []; // Stores list of all users
  Set<int> _deletedUserIds = {}; // Keeps track of users who were deleted
  bool _isLoading = false; // Indicates if data is being fetched

  // Getters to access private variables from outside
  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;

  // Fetch users from API (optionally paginated)
  Future<void> fetchUsers({int page = 1}) async {
    _isLoading = true;
    notifyListeners(); // Notify UI to show loading indicator

    List<UserModel> fetched = await _apiService.fetchUsers(page);

    // Filter out any users that were marked as deleted
    _users = fetched.where((user) => !_deletedUserIds.contains(user.id)).toList();

    _isLoading = false;
    notifyListeners(); // Notify UI to rebuild with new data
  }

  // Deletes a user from API and local list
  Future<void> deleteUser(int id) async {
    final success = await _apiService.deleteUser(id);
    if (success) {
      _deletedUserIds.add(id); // Mark user as deleted
      _users.removeWhere((user) => user.id == id); // Remove from list
      notifyListeners(); // Update UI
    }
  }

  // Updates a user's job title
  Future<bool> updateUser(int id, String name, String job) async {
    final success = await _apiService.updateUser(id, name, job);
    if (success) {
      // If user exists in the list, update the job field
      final index = _users.indexWhere((user) => user.id == id);
      if (index != -1) {
        _users[index].job = job;
        notifyListeners();
      }
      return true;
    }
    return false;
  }

  // Creates a new user and adds them to the top of the list
  Future<bool> createUser(String name, String job) async {
    final success = await _apiService.createUser(name, job);
    if (success) {
      // Split full name into first and last name
      final parts = name.trim().split(' ');
      final firstName = parts.isNotEmpty ? parts[0] : '';
      final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

      // Generate dummy user data since API doesn't return actual user
      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch, // Using timestamp as fake ID
        firstName: firstName,
        lastName: lastName,
        email: '${firstName.toLowerCase()}.${lastName.toLowerCase()}@reqres.in',
        avatar: 'https://i.pravatar.cc/150?img=${_users.length + 1}', // Dummy avatar
      );

      _users.insert(0, newUser); // Add user at the top
      notifyListeners(); // Update UI
      return true;
    }
    return false;
  }
}