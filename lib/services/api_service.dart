import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = "https://reqres.in/api";
  final storage = const FlutterSecureStorage(); // Secure storage to save token locally

  // Logs in the user and stores the token if successful
  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'token', value: data['token']); // Save token securely
      return data['token'];
    } else {
      return null; // Login failed
    }
  }

  // Registers the user and stores the token if successful
  Future<String?> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'token', value: data['token']); // Save token securely
      return data['token'];
    } else {
      return null; // Registration failed
    }
  }

  // Fetches list of users from a specific page
  Future<List<UserModel>> fetchUsers(int page) async {
    final response = await http.get(Uri.parse('$baseUrl/users?page=$page'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List users = data['data'];
      return users.map((user) => UserModel.fromJson(user)).toList(); // Convert to UserModel list
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Deletes a user by ID
  Future<bool> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));
    return response.statusCode == 204; // 204 means successfully deleted
  }

  // Updates a user's name and job
  Future<bool> updateUser(int id, String name, String job) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      body: {
        'name': name,
        'job': job,
      },
    );
    return response.statusCode == 200; // Success
  }

  // Creates a new user
  Future<bool> createUser(String name, String job) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      body: {
        'name': name,
        'job': job,
      },
    );
    return response.statusCode == 201; // 201 means resource created
  }

  // Clears all saved data from secure storage (used during logout)
  Future<void> logout() async {
    await storage.deleteAll();
  }

  // Retrieves saved token from secure storage
  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }
}