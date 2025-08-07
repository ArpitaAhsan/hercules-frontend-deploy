import 'package:flutter/material.dart';
import 'package:hercules/blog_post.dart';
import 'package:hercules/feedback_page.dart';
import 'package:hercules/location_page.dart'; // For Menus & MyBottomNavigation
import 'package:hercules/home_page.dart';
import 'package:hercules/nearby_page.dart';
import 'package:hercules/call_help.dart';
import 'package:hercules/activity_log.dart';

class BlogFeedPage extends StatefulWidget {
  const BlogFeedPage({super.key});

  @override
  State<BlogFeedPage> createState() => _BlogFeedPageState();
}

class _BlogFeedPageState extends State<BlogFeedPage> {
  Menus currentIndex = Menus.add;

  final ScrollController _scrollController = ScrollController();

  void updatePageIndex(int index) {
    setState(() {
      currentIndex = Menus.values[index];
    });
  }

  Widget get _blogFeedBody => DefaultTabController(
    length: 2,
    child: Column(
      children: const [
        TabBar(
          labelColor: Colors.yellow,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.yellow,
          tabs: [
            Tab(text: 'Blogs'),
            Tab(text: 'Feedbacks'),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              BlogPostPage(),
              FeedbackPage(),
            ],
          ),
        ),
      ],
    ),
  );

  List<Widget> get pages => [
    const HomePage(),
    const NearbyPage(),
    _blogFeedBody,
    const CallHelpPage(),
    ActivityLogPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentIndex == Menus.add
          ? AppBar(title: const Text('Blogs & Feedbacks'))
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
