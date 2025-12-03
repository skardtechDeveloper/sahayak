class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String language;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.language = 'en',
  });
}
