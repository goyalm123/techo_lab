import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

// A splash screen that checks the authentication status
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Start the auth check as soon as the screen is initialized
  }

  // Method to check whether the user is authenticated or not
  Future<void> _checkLoginStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await authProvider.checkAuth(); // Check if user is already authenticated
    await Future.delayed(const Duration(seconds: 2)); // Add a slight delay to show splash screen

    // Navigate to the appropriate screen based on auth status
    if (authProvider.isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Company logo shown at the center of the splash screen
            Image.asset(
              'assets/images/techolab_logo.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 24),
            // Shows a loading spinner while checking auth status
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}