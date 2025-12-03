import 'package:flutter/material.dart';

void main() {
  runApp(const SahayakApp());
}

class SahayakApp extends StatelessWidget {
  const SahayakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sahayak AI Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  String _currentLanguage = 'en';
  bool _isListening = false;

  final List<Map<String, dynamic>> _tools = [
    {
      'icon': Icons.translate,
      'title': 'Translate',
      'description': 'Translate between Nepali and English',
      'color': Colors.green,
    },
    {
      'icon': Icons.document_scanner,
      'title': 'Scan Document',
      'description': 'Scan and extract text from documents',
      'color': Colors.blue,
    },
    {
      'icon': Icons.record_voice_over,
      'title': 'Speech to Text',
      'description': 'Convert speech to text in both languages',
      'color': Colors.orange,
    },
    {
      'icon': Icons.text_fields,
      'title': 'Text to Speech',
      'description': 'Convert text to speech output',
      'color': Colors.purple,
    },
    {
      'icon': Icons.date_range,
      'title': 'Date Converter',
      'description': 'Convert between Nepali and English dates',
      'color': Colors.red,
    },
    {
      'icon': Icons.description,
      'title': 'Resume Builder',
      'description': 'Create professional CVs and resumes',
      'color': Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('सहायक AI'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: _getPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _getPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildChatPage();
      case 1:
        return _buildToolsPage();
      case 2:
        return _buildProfilePage();
      default:
        return _buildChatPage();
    }
  }

  Widget _buildChatPage() {
    return Column(
      children: [
        Expanded(
          child: _messages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.smart_toy,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Welcome to Sahayak AI',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Ask me anything in ${_currentLanguage == 'ne' ? 'नेपाली' : 'English'}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: _toggleLanguage,
                        icon: Icon(
                          _currentLanguage == 'ne'
                              ? Icons.language
                              : Icons.translate,
                        ),
                        label: Text(
                          _currentLanguage == 'ne'
                              ? 'Switch to English'
                              : 'नेपालीमा स्विच गर्नुहोस्',
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return _buildMessageBubble(
                      message['text'],
                      message['isUser'],
                      message['timestamp'],
                    );
                  },
                ),
        ),
        _buildChatInput(),
      ],
    );
  }

  Widget _buildChatInput() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border(top: BorderSide(color: colorScheme.outline)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _currentLanguage == 'ne' ? Icons.language : Icons.translate,
            ),
            onPressed: _toggleLanguage,
            tooltip: 'Change Language',
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: _currentLanguage == 'ne'
                    ? 'सन्देश लेख्नुहोस्...'
                    : 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onSubmitted: (value) => _sendMessage(value),
            ),
          ),
          const SizedBox(width: 8),
          _isListening
              ? const _VoiceWaveAnimation()
              : IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: _toggleListening,
                  tooltip: 'Voice Input',
                ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () => _sendMessage(_controller.text),
            style: FilledButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
            ),
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isUser, DateTime timestamp) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isUser ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 11,
                color: isUser
                    ? _colorWithOpacity(colorScheme.onPrimary, 0.7)
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolsPage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI Tools',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Powerful tools for your daily tasks',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: _tools.length,
              itemBuilder: (context, index) {
                final tool = _tools[index];
                return _buildToolCard(
                  tool['icon'] as IconData,
                  tool['title'] as String,
                  tool['description'] as String,
                  tool['color'] as Color,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(
      IconData icon, String title, String description, Color color) {
    return Card(
      elevation: 2, // Reduced from 4 for better Material 3 look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showToolDialog(title),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _createColorWithOpacity(color, 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePage() {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 50,
          backgroundColor: colorScheme.primary,
          child: Icon(Icons.person, size: 60, color: colorScheme.onPrimary),
        ),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Guest User',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'Free Plan',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 40),
        Divider(color: colorScheme.outline),
        _buildProfileItem(Icons.upgrade, 'Upgrade to Premium', () {}),
        _buildProfileItem(Icons.history, 'Chat History', () {}),
        _buildProfileItem(Icons.document_scanner, 'My Documents', () {}),
        _buildProfileItem(Icons.settings, 'Settings', () {}),
        _buildProfileItem(Icons.help, 'Help & Support', () {}),
        _buildProfileItem(Icons.info, 'About Sahayak', () {}),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Login / Signup'),
        ),
      ],
    );
  }

  Widget _buildProfileItem(IconData icon, String title, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios,
          size: 16, color: colorScheme.onSurfaceVariant),
      onTap: onTap,
    );
  }

  void _toggleLanguage() {
    setState(() {
      _currentLanguage = _currentLanguage == 'en' ? 'ne' : 'en';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _currentLanguage == 'ne'
              ? 'भाषा नेपालीमा परिवर्तन गरियो'
              : 'Language changed to English',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });
    if (_isListening) {
      // Simulate voice input
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isListening = false;
          _sendMessage('Hello from voice input');
        });
      });
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': text,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
      _controller.clear();
    });

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add({
          'text': _getAIResponse(text),
          'isUser': false,
          'timestamp': DateTime.now(),
        });
      });
    });
  }

  String _getAIResponse(String userMessage) {
    final responses = {
      'en': [
        'I understand you asked: "$userMessage". How can I help you today?',
        'Thanks for your question! Let me think about that...',
        'I\'m analyzing your query. Could you provide more details?',
        'Based on your question, I suggest checking our documentation.',
        'I can help you with that. What specific information do you need?',
      ],
      'ne': [
        'तपाईंले सोध्नुभएको प्रश्न: "$userMessage"। आज म कसरी मद्दत गर्न सक्छु?',
        'तपाईंको प्रश्नको लागि धन्यवाद! म त्यसबारे सोच्दैछु...',
        'म तपाईंको प्रश्नको विश्लेषण गर्दैछु। कृपया थप विवरण दिनुहोस्।',
        'तपाईंको प्रश्नको आधारमा, म हाम्रो कागजातहरू जाँच गर्न सिफारिस गर्दछु।',
        'म त्यसमा तपाईंलाई मद्दत गर्न सक्छु। तपाईंलाई के विशेष जानकारी चाहियो?',
      ],
    };

    final langResponses = responses[_currentLanguage] ?? responses['en']!;
    return langResponses[DateTime.now().millisecond % langResponses.length];
  }

  void _showToolDialog(String toolName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(toolName),
        content: Text('$toolName feature will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Helper method to create color with opacity without deprecation - FIXED
  Color _createColorWithOpacity(Color color, double opacity) {
    // Use the new component accessors instead of color.value
    final a = (color.alpha * opacity).round().clamp(0, 255);
    final r = color.red;
    final g = color.green;
    final b = color.blue;

    return Color.fromARGB(a, r, g, b);
  }

  // Helper method for creating colors with opacity - FIXED
  Color _colorWithOpacity(Color color, double opacity) {
    // Use the new component accessors instead of color.value
    final a = (color.alpha * opacity).round().clamp(0, 255);
    final r = color.red;
    final g = color.green;
    final b = color.blue;

    return Color.fromARGB(a, r, g, b);
  }
}

class _VoiceWaveAnimation extends StatelessWidget {
  const _VoiceWaveAnimation();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.mic,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}
