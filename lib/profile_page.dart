import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hercules/config/app_routes.dart';
import 'package:hercules/profile_provider.dart';
import 'package:hercules/change_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final ScrollController scrollController;
  final Function(int) updatePageIndex;

  const ProfilePage({super.key, required this.scrollController, required this.updatePageIndex});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.fetchUserProfile(userId);
    } else {
      print("❌ No user ID found in SharedPreferences");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return Scaffold(
          body: CustomScrollView(
            controller: widget.scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Colors.black87,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage("https://via.placeholder.com/150"),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          profileProvider.name.isNotEmpty ? profileProvider.name : "Loading...",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,  // White text here
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profileProvider.email.isNotEmpty ? profileProvider.email : "Loading email...",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,  // White text here
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 20),
                    _buildSectionTitle("Account", context),

                    _buildProfileOption(
                      context,
                      icon: Icons.person_outline,
                      title: "Edit Profile",
                      subtitle: "Update your personal details",
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.editProfile);
                      },
                      backgroundColor: const Color(0xFFDAF0FF),
                      iconBgColor: const Color(0xFF8FCBFF),
                    ),

                    _buildProfileOption(
                      context,
                      icon: Icons.lock_outline,
                      title: "Change Password",
                      subtitle: "Update your password for security",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                        );
                      },
                      backgroundColor: const Color(0xFFFEE7DA),
                      iconBgColor: const Color(0xFFFFB07C),
                    ),

                    const SizedBox(height: 20),
                    _buildSectionTitle("Preferences", context),

                    _buildProfileOption(
                      context,
                      icon: Icons.notifications_outlined,
                      title: "Permission Settings",
                      subtitle: "Manage your permissions",
                      onTap: () => print("Navigate to Permission Settings"),
                      backgroundColor: const Color(0xFFD6F5E1),
                      iconBgColor: const Color(0xFF8DD69E),
                    ),

                    const SizedBox(height: 20),
                    _buildSectionTitle("Activity", context),

                    _buildProfileOption(
                      context,
                      icon: Icons.history_outlined,
                      title: "Service History",
                      subtitle: "Check your past services",
                      onTap: () => print("Navigate to Service History"),
                      backgroundColor: const Color(0xFFF6D6F0),
                      iconBgColor: const Color(0xFFDB8CD6),
                    ),

                    _buildProfileOption(
                      context,
                      icon: Icons.star_outline,
                      title: "Your Reviews",
                      subtitle: "Manage and view your reviews",
                      onTap: () => print("Navigate to Your Reviews"),
                      backgroundColor: const Color(0xFFFFE8A1),
                      iconBgColor: const Color(0xFFFFD555),
                    ),

                    const SizedBox(height: 20),
                    _buildSectionTitle("Support", context),

                    _buildProfileOption(
                      context,
                      icon: Icons.help_outline,
                      title: "Help & Feedback",
                      subtitle: "Contact us for assistance",
                      onTap: () => print("Navigate to Help & Feedback"),
                      backgroundColor: const Color(0xFFCEE3F6),
                      iconBgColor: const Color(0xFF94BFFB),
                    ),

                    const SizedBox(height: 20),
                    _buildSectionTitle("Logout", context),

                    _buildProfileOption(
                      context,
                      icon: Icons.login_outlined,
                      title: "Log Out",
                      titleColor: Colors.red,
                      subtitle: "Log out of your account",
                      onTap: () => _showLogOutDialog(context),
                      backgroundColor: const Color(0xFFFDEDED),
                      iconBgColor: const Color(0xFFFAB6B6),
                      iconColor: Colors.red,
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Section Titles with white text
  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,  // <-- White text here
        ),
      ),
    );
  }

  Widget _buildProfileOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
        Color? backgroundColor,
        Color? iconBgColor,
        Color? iconColor,
        Color? titleColor,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: iconBgColor ?? Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(icon, size: 28, color: iconColor ?? Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor ?? Theme.of(context).textTheme.bodyLarge!.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showLogOutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to log out?'),
          content: const Text('You will be redirected to the login page.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.login, (route) => false,
                );
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}
