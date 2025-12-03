import '../entities/chat_message.dart'; // Update with the correct path
import 'package:flutter/foundation.dart';

class SaveChatHistoryParams {
  final ChatMessage userMessage; // Change from Map to ChatMessage
  final ChatMessage aiMessage;

  SaveChatHistoryParams({
    required this.userMessage,
    required this.aiMessage,
  });
}

class SaveChatHistory {
  Future<void> call(SaveChatHistoryParams params) async {
    // This would save to local storage or Firebase
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('Chat history saved');
  }
}
