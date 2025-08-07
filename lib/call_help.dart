import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hercules/location_page.dart'; // For Menus & MyBottomNavigation
import 'package:hercules/home_page.dart';
import 'package:hercules/nearby_page.dart';
import 'package:hercules/activity_log.dart';
import 'package:hercules/blog_feed.dart';

class CallHelpPage extends StatefulWidget {
  const CallHelpPage({super.key});

  @override
  State<CallHelpPage> createState() => _CallHelpPageState();
}

class _CallHelpPageState extends State<CallHelpPage> {
  Menus currentIndex = Menus.messages;

  void updatePageIndex(int index) {
    setState(() {
      currentIndex = Menus.values[index];
    });
  }

  final List<Widget> pages = const [
    HomePage(),
    NearbyPage(),
    BlogFeedPage(),
    CallHelpUI(),         // ✅ Use proper widget instead of method
    ActivityLogPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentIndex == Menus.messages
          ? AppBar(
        title: const Text("Call Help"),
        backgroundColor: Color(0xFFD8B4F2),
        elevation: 0,
      )
          : null,
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

// ✅ A separate widget for Call Help UI
class CallHelpUI extends StatelessWidget {
  const CallHelpUI({super.key});

  Future<void> _callNumber(String number) async {
    final Uri phoneUri = Uri.parse('tel:$number');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      debugPrint('Could not launch $number');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.phone, size: 100, color: Color(0xFF90ADC6)),
          const SizedBox(height: 20),
          const Text(
            'Calling for help...',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => _callNumber('01919'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009688),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text('Call Police', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _callNumber('01819'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text('Call Fire Brigade', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
