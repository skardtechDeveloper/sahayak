import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sahayak AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to Sahayak',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your AI Assistant for Nepal',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildActionCard(
                  context,
                  icon: Icons.chat,
                  title: 'AI Chat',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pushNamed(context, '/chat');
                  },
                ),
                _buildActionCard(
                  context,
                  icon: Icons.document_scanner,
                  title: 'Scan Document',
                  color: Colors.green,
                  onTap: () {},
                ),
                _buildActionCard(
                  context,
                  icon: Icons.record_voice_over,
                  title: 'Voice Assistant',
                  color: Colors.orange,
                  onTap: () {},
                ),
                _buildActionCard(
                  context,
                  icon: Icons.translate,
                  title: 'Translate',
                  color: Colors.purple,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Recent Activity
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),

            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  leading: const Icon(Icons.chat_bubble),
                  title: const Text('AI Chat Session'),
                  subtitle: const Text('2 hours ago'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.document_scanner),
                  title: const Text('Document Scanned'),
                  subtitle: const Text('Yesterday'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.translate),
                  title: const Text('Translation Saved'),
                  subtitle: const Text('2 days ago'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
