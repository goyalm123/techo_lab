import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techo_lab/providers/auth_provider.dart';
import 'package:techo_lab/providers/user_provider.dart';
import 'package:techo_lab/screens/splash_screen.dart';

// Entry point of the app
void main() {
  runApp(const MyApp());
}

// Root widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Providing multiple providers to the entire app
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()), // Handles login, register, logout logic
        ChangeNotifierProvider(create: (_) => UserProvider()), // Handles user list, create, update, delete
      ],
      child: MaterialApp(
        title: 'Techo Lab',
        debugShowCheckedModeBanner: false, // Hides the debug banner
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
