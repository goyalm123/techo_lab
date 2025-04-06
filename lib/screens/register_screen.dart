import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Form key to validate input fields
  final _formKey = GlobalKey<FormState>();

  // Controllers to manage input text
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // UI state variables
  bool _isLoading = false; // For loading indicator
  bool _obscurePassword = true; // Toggle password visibility
  final Color primaryColor = Colors.blueAccent; // Theme color

  @override
  void initState() {
    super.initState();

    // Set status bar color to match the top container
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  // Function to handle user registration
  void _register() async {
    // Validate form fields
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Access the AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Attempt registration with email and password
      final success = await authProvider.register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      setState(() => _isLoading = false);

      // Navigate to HomeScreen if successful
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        // Show error if registration fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration failed")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with app name
      appBar: AppBar(
        title: const Text("TechoLab"),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Decorative top container with title
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Text(
                "Create your account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Registration form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email input field
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? "Please enter email" : null,
                    ),

                    const SizedBox(height: 20),

                    // Password input field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword, // Toggle visibility
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            // Toggle password visibility
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? "Please enter password" : null,
                    ),

                    const SizedBox(height: 30),

                    // Register button or loader
                    _isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: primaryColor,
                        ),
                        onPressed: _register, // Call register function
                        child: const Text(
                          "Register",
                          style: TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Redirect to login screen
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child:
                      const Text("Already have an account? Login here"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Clean up controllers to prevent memory leaks
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}