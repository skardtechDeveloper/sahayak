import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../core/constants/api_constants.dart';

class AIChatService {
  final Dio _dio = Dio();
  final Box _chatCache = Hive.box('chat_cache');

  Future<String> generateResponse({
    required String prompt,
    required String language,
    bool useOffline = false,
  }) async {
    try {
      // Check connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOnline = connectivityResult.isNotEmpty &&
          connectivityResult.any((result) =>
              result == ConnectivityResult.mobile ||
              result == ConnectivityResult.wifi ||
              result == ConnectivityResult.ethernet);

      // If offline mode requested or no internet
      if (useOffline || !isOnline) {
        return await _generateOfflineResponse(prompt, language);
      }

      // Try cloud AI first
      try {
        return await _generateCloudResponse(prompt, language);
      } catch (e) {
        // Fallback to offline
        return await _generateOfflineResponse(prompt, language);
      }
    } catch (e) {
      return 'माफ गर्नुहोस्, म जवाफ दिन असक्षम छु। कृपया पुनः प्रयास गर्नुहोस्।';
    }
  }

  Future<String> _generateCloudResponse(String prompt, String language) async {
    // Check cache first
    final cacheKey = '${prompt.hashCode}_$language';
    final cached = _chatCache.get(cacheKey);
    if (cached != null) return cached;

    // Prepare API request
    final messages = [
      {
        'role': 'system',
        'content': '''
        You are Sahayak, a helpful AI assistant for Nepali users.
        Respond in $language. Be concise, accurate, and culturally appropriate.
        For Nepali: Use Devanagari script. Be respectful and formal.
        For English: Use simple, clear language.
        '''
      },
      {'role': 'user', 'content': prompt}
    ];

    final response = await _dio.post(
      ApiConstants.openaiChatEndpoint,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${ApiConstants.openaiApiKey}',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'model': 'gpt-4-turbo-preview',
        'messages': messages,
        'temperature': 0.7,
        'max_tokens': 1000,
      },
    );

    final responseText = response.data['choices'][0]['message']['content'];

    // Cache the response
    await _chatCache.put(cacheKey, responseText);

    return responseText;
  }

  Future<String> _generateOfflineResponse(
      String prompt, String language) async {
    // Simple rule-based responses for offline mode
    final offlineResponses = {
      'ne': {
        'नमस्ते': 'नमस्ते! म सहायक हुँ। तपाईंलाई कसरी मद्दत गर्न सक्छु?',
        'तिम्रो नाम के हो': 'मेरो नाम सहायक हो। म तपाईंको AI सहायक हुँ।',
        'धन्यवाद': 'स्वागतम्! फेरि भेटौंला।',
        'अलविदा': 'अलविदा! राम्रो दिन होस्।',
      },
      'en': {
        'hello': 'Hello! I am Sahayak. How can I help you today?',
        'what is your name': 'My name is Sahayak. I am your AI assistant.',
        'thank you': 'You are welcome! Have a great day.',
        'goodbye': 'Goodbye! Take care.',
      },
    };

    final langResponses = offlineResponses[language] ?? offlineResponses['en']!;

    // Try to find matching response
    for (final key in langResponses.keys) {
      if (prompt.toLowerCase().contains(key.toLowerCase())) {
        return langResponses[key]!;
      }
    }

    // Default response
    return language == 'ne'
        ? 'माफ गर्नुहोस्, म यो प्रश्नको उत्तर दिन सक्दिन। कृपया इन्टरनेट जडान गर्नुहोस्।'
        : 'Sorry, I cannot answer this question offline. Please connect to the internet.';
  }

  // Stream responses for real-time effect
  Stream<String> generateStreamingResponse({
    required String prompt,
    required String language,
  }) async* {
    final simulatedResponse = language == 'ne'
        ? 'तपाईंको प्रश्नको विश्लेषण गर्दै...'
        : 'Analyzing your question...';

    yield simulatedResponse;

    await Future.delayed(const Duration(seconds: 1));

    final response = await generateResponse(
      prompt: prompt,
      language: language,
    );

    // Stream response word by word
    final responseWords = response.split(' ');
    for (final word in responseWords) {
      await Future.delayed(const Duration(milliseconds: 50));
      yield responseWords.sublist(0, responseWords.indexOf(word) + 1).join(' ');
    }
  }
}
