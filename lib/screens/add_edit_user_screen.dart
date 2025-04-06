import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

// This screen handles both adding a new user and editing an existing one
class AddEditUserScreen extends StatefulWidget {
  final int? userId; // if userId is passed, we're in edit mode

  const AddEditUserScreen({super.key, this.userId});

  @override
  State<AddEditUserScreen> createState() => _AddEditUserScreenState();
}

class _AddEditUserScreenState extends State<AddEditUserScreen> {
  // Controllers to handle input fields for name and job
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();

  // This flag tells us if we're editing an existing user
  late bool isEditing;

  final Color primaryColor = Colors.blueAccent;

  @override
  void initState() {
    super.initState();

    // Check if we're editing or adding
    isEditing = widget.userId != null;

    // If editing, pre-fill the fields with the existing user's data
    if (isEditing) {
      final user = Provider.of<UserProvider>(context, listen: false)
          .users
          .firstWhere((u) => u.id == widget.userId);
      _nameController.text = '${user.firstName} ${user.lastName}';
      _jobController.text = user.job ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Users"),
        titleSpacing: 0,
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          // Header section with background and title
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title changes based on mode (add/edit)
                Text(
                  isEditing ? 'Edit User' : 'Add User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isEditing
                      ? "Update user details below"
                      : "Fill in the form to add a new user",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Form section starts here
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Name input
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Job input
                  TextField(
                    controller: _jobController,
                    decoration: const InputDecoration(
                      labelText: 'Job',
                      prefixIcon: Icon(Icons.work),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final name = _nameController.text.trim();
                        final job = _jobController.text.trim();

                        // Check if fields are empty
                        if (name.isEmpty || job.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('All fields are required')),
                          );
                          return;
                        }

                        final provider = Provider.of<UserProvider>(context,
                            listen: false);
                        bool success = false;

                        // If editing, call update
                        if (isEditing) {
                          success = await provider.updateUser(
                              widget.userId!, name, job);
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('User updated successfully')),
                            );
                          }
                        } else {
                          // Otherwise, create a new user
                          success = await provider.createUser(name, job);
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('User created successfully')),
                            );
                          }
                        }

                        // Go back if everything was successful
                        if (success) {
                          Navigator.pop(context, true);
                        }
                      },
                      child: Text(
                        isEditing ? 'Update User' : 'Add User',
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}