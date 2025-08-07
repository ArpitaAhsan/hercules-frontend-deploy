import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hercules/profile_page.dart';
import 'package:hercules/nearby_page.dart';
import 'package:hercules/home_page.dart';
import 'package:hercules/blog_feed.dart';
import 'package:hercules/call_help.dart';
import 'package:hercules/location_page.dart'; // for Menus & MyBottomNavigation

const String apiBaseUrl = "http://192.168.0.101:9062";

class ActivityLogPage extends StatefulWidget {
  const ActivityLogPage({super.key});

  @override
  State<ActivityLogPage> createState() => _ActivityLogPageState();
}

class _ActivityLogPageState extends State<ActivityLogPage> {
  Menus currentIndex = Menus.user; // Represents the selected tab
  final ScrollController scrollController = ScrollController();

  List<dynamic> alerts = [];
  bool isLoading = true;
  String? loggedInUserId;
  String? loggedInEmail;

  @override
  void initState() {
    super.initState();
    loadUserInfoAndFetchAlerts();
  }

  void updatePageIndex(int index) {
    setState(() {
      currentIndex = Menus.values[index];
    });
  }

  Future<void> loadUserInfoAndFetchAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getString('userId');
    final storedEmail = prefs.getString('email');

    if (storedUserId != null) {
      setState(() {
        loggedInUserId = storedUserId;
        loggedInEmail = storedEmail ?? "unknown@example.com";
      });
      await fetchAlerts(storedUserId);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAlerts(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/api/auth/alerts/$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          alerts = data;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> submitFeedback(String emergencyType) async {
    TextEditingController emailController = TextEditingController();
    TextEditingController feedbackController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Feedback'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailController.text.trim();
              final feedbackText = feedbackController.text.trim();

              if (email.isEmpty || feedbackText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Both fields are required')),
                );
                return;
              }

              try {
                final response = await http.post(
                  Uri.parse('$apiBaseUrl/api/auth/feedback/create'),
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode({
                    'email': email,
                    'emergencyType': emergencyType,
                    'feedback': feedbackText,
                  }),
                );

                if (response.statusCode == 201) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feedback submitted!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed: ${response.statusCode}')),
                  );
                }
              } catch (e) {
                print("Error submitting feedback: $e");
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> markAlertAsDone(String alertId, String emergencyType) async {
    try {
      final response = await http.put(
        Uri.parse('$apiBaseUrl/api/auth/alert/finish/$alertId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          alerts = alerts.map((alert) {
            if (alert['_id'] == alertId) {
              alert['finishedAt'] = DateTime.now().toIso8601String();
              alert['alertColor'] = 'grey';
            }
            return alert;
          }).toList();
        });

        await submitFeedback(emergencyType);
      }
    } catch (e) {
      print("Error marking alert done: $e");
    }
  }

  Widget buildAlertCard(dynamic alert) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      color: alert['isEmergency'] == true ? Colors.red[100] : const Color(0xFFFAD02C),
      child: ListTile(
        title: Text("Type: ${alert['emergencyType'] ?? 'Unknown'}"),
        subtitle: Text("Created: ${alert['createdAt'] ?? 'N/A'}"),
        trailing: alert['finishedAt'] != null
            ? const Text("Finished", style: TextStyle(color: Colors.green))
            : ElevatedButton(
          onPressed: () => markAlertAsDone(alert['_id'], alert['emergencyType']),
          child: const Text("Done"),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF90ADC6)),
        ),
      ),
    );
  }

  Widget get _activityLogBody {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity Log"),
          backgroundColor:Color(0xFFA5D6A7),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'goToProfile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      scrollController: scrollController,
                      updatePageIndex: updatePageIndex,
                    ),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'goToProfile',
                child: Text('Go to Profile'),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : alerts.isEmpty
          ? const Center(child: Text("No alerts found."))
          : ListView.builder(
        controller: scrollController,
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          return buildAlertCard(alerts[index]);
        },
      ),
    );
  }

  List<Widget> get pages => [
    const HomePage(),
    const NearbyPage(),
    const BlogFeedPage(),
    const CallHelpPage(),
    _activityLogBody,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: pages[currentIndex.index],
      ),
      bottomNavigationBar: MyBottomNavigation(
        currentIndex: currentIndex,
        onTap: (menu) => updatePageIndex(menu.index),
      ),
    );
  }
}
