import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:techo_lab/screens/user_list_screen.dart';
import 'package:techo_lab/widgets/card_layout.dart';

import '../providers/auth_provider.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Setting a primary color once so it's reused consistently
  final Color primaryColor = Colors.blueAccent;

  @override
  void initState() {
    super.initState();

    // Changing status bar color to match the top part of the screen
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      statusBarIconBrightness: Brightness.light, // White icons
    ));
  }

  // This handles the logout logic
  void _logout(BuildContext context) {
    // Tell the auth provider to log the user out
    Provider.of<AuthProvider>(context, listen: false).logout();

    // Push the login screen and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false, // Remove all previous screens from the stack
    );
  }

  // Navigate to the user list screen
  void _goToUserList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UserListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("TechoLab"),
      ),
      body: Column(
        children: [
          // The top section with app title — styled with a curved bottom
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  "Management App",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Buttons below the header for navigating to "Manage Users" and "Logout"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Taps into the user list screen
                CardLayout(
                  icon: Icons.people,
                  title: 'Manage Users',
                  iconColor: primaryColor,
                  onTap: () => _goToUserList(context),
                ),
                const SizedBox(height: 12),
                // Logs the user out and navigates back to login screen
                CardLayout(
                  icon: Icons.logout,
                  title: 'Logout',
                  iconColor: Colors.redAccent,
                  onTap: () => _logout(context),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}