import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Mock discussions
    final List<Map<String, String>> discussions = [
      {
        'title': 'Blowout Preventer Pressure Settings',
        'desc': 'Does anyone have the latest API chart for hydrostatic pressure testing on subsea BOP stacks?',
        'author': 'Marcus Vance',
        'time': '12 mins ago',
        'replies': '4 replies',
      },
      {
        'title': 'Tips on passing HUET Certification',
        'desc': 'Just completed my Helicopter Underwater Escape Training! Here is a guide on what to expect during the simulation.',
        'author': 'David Chen',
        'time': '2 hours ago',
        'replies': '15 replies',
      },
      {
        'title': 'Safety Guidelines for Offshore Crane Operators',
        'desc': 'A quick reminder to inspect the hoist lines and safety locks before shifting loads during high sea winds.',
        'author': 'Sarah J.',
        'time': 'Yesterday',
        'replies': '8 replies',
      },
    ];

    // Mock announcements
    final List<Map<String, String>> announcements = [
      {
        'title': 'Platform Safety Protocol Update V3.1',
        'desc': 'All offshore workers are required to review the new gas detection alarms and hazard response layout changes before June 20th.',
        'author': 'HSE Command',
        'time': '1 hour ago',
        'importance': 'CRITICAL',
      },
      {
        'title': 'Scheduled Server Maintenance',
        'desc': 'Zenvora LMS portals will undergo system database updates this Saturday from 02:00 to 05:00 UTC. The app will be offline.',
        'author': 'Zenvora Support',
        'time': '1 day ago',
        'importance': 'NORMAL',
      },
      {
        'title': 'New Course Added: Advanced Well Control',
        'desc': 'Unlock advanced lessons covering subsea control panels, kick detection algorithms, and API RP 59 compliance standards.',
        'author': 'Training Team',
        'time': '3 days ago',
        'importance': 'INFO',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Feed'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colorScheme.primary,
          labelColor: colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Discussions'),
            Tab(text: 'Announcements'),
          ],
        ),
      ),
      drawer: const CustomDrawer(activeItem: DrawerItem.community),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Discussions Tab
          ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: discussions.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final post = discussions[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primary.withOpacity(0.1),
                  child: Text(
                    post['author']!.substring(0, 1),
                    style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          post['author']!,
                          style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          post['time']!,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post['title']!,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['desc']!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: Colors.grey[800], height: 1.35),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.mode_comment_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            post['replies']!,
                            style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Announcements Tab
          ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: announcements.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final post = announcements[index];
              final isCritical = post['importance'] == 'CRITICAL';
              final badgeColor = isCritical ? Colors.redAccent : (post['importance'] == 'INFO' ? Colors.blue : Colors.grey);

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCritical ? Icons.campaign : Icons.notifications,
                    color: badgeColor,
                    size: 24,
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: badgeColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            post['importance']!,
                            style: TextStyle(fontSize: 9, color: badgeColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          post['time']!,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      post['title']!,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    post['desc']!,
                    style: TextStyle(fontSize: 13, color: Colors.grey[800], height: 1.35),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
