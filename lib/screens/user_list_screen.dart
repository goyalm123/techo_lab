import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techo_lab/models/user_model.dart';
import 'package:techo_lab/widgets/custom_expandable_tile.dart';
import '../providers/user_provider.dart';
import 'add_edit_user_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  // Controller for the search bar
  final TextEditingController _searchController = TextEditingController();

  // This will store the users after filtering based on search input
  List<UserModel> _filteredUsers = [];

  // Theme color for consistency
  final Color primaryColor = Colors.blueAccent;

  @override
  void initState() {
    super.initState();
    // Load users after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUsers();
    });
  }

  // Fetch users from the provider and assign them to the filtered list
  void _loadUsers() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUsers();
    _filteredUsers = userProvider.users;
    setState(() {}); // Refresh UI after fetching
  }

  // Search functionality: filter users by name or email
  void _onSearchChanged(String query) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final users = userProvider.users;

    setState(() {
      _filteredUsers = users.where((user) {
        final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
        final email = user.email.toLowerCase();
        return fullName.contains(query.toLowerCase()) ||
            email.contains(query.toLowerCase());
      }).toList();
    });
  }

  // Navigate to add/edit screen (pass userId if editing)
  void _navigateToAddEditUser({int? userId}) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditUserScreen(userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isLoading = userProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        titleSpacing: 0,
        backgroundColor: primaryColor,
        actions: [
          // Refresh button to reload users and clear search
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _searchController.clear();
              _loadUsers();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header section with title and search bar
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
                const Text(
                  "User Directory",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Search input
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: "Search user...",
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Show loading spinner if users are still being fetched
          isLoading
              ? const Expanded(child: Center(child: CircularProgressIndicator()))
              : Expanded(
            // If no results found
            child: _filteredUsers.isEmpty
                ? const Center(child: Text("No users found"))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _filteredUsers.length,
              itemBuilder: (_, index) {
                final user = _filteredUsers[index];
                return CustomExpandableTile(
                  title: '${user.firstName} ${user.lastName}',
                  subtitle: user.email,
                  avatarUrl: user.avatar,
                  onEdit: () =>
                      _navigateToAddEditUser(userId: user.id),
                  onDelete: () async {
                    // Confirm before deleting a user
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Confirm Delete"),
                        content: const Text(
                            "Are you sure you want to delete this user?"),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, true),
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    );

                    // Delete user if confirmed
                    if (confirmed == true) {
                      await userProvider.deleteUser(user.id);
                      _loadUsers(); // Reload list
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                            Text("User deleted successfully")),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Floating button to add new user
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => _navigateToAddEditUser(),
        child: const Icon(Icons.add),
      ),
    );
  }
}