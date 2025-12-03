class ApiConstants {
  // OpenAI API
  static const String openaiBaseUrl = 'https://api.openai.com/v1';
  static const String openaiChatEndpoint = '$openaiBaseUrl/chat/completions';
  static const String openaiCompletionEndpoint = '$openaiBaseUrl/completions';
  static const String openaiImageEndpoint = '$openaiBaseUrl/images/generations';
  static const String openaiSpeechEndpoint = '$openaiBaseUrl/audio/speech';
  static const String openaiTranscriptionEndpoint =
      '$openaiBaseUrl/audio/transcriptions';

  // Google Cloud APIs
  static const String googleVisionApi =
      'https://vision.googleapis.com/v1/images:annotate';
  static const String googleTranslateApi =
      'https://translation.googleapis.com/language/translate/v2';

  // Nepali Services
  static const String nepaliDateApi =
      'https://nepalicalendar.rat32.com/api/v1/date';
  static const String nepaliHolidaysApi =
      'https://date.nager.at/api/v3/publicholidays/2024/NP';

  // Payment Gateways
  static const String razorpayApi = 'https://api.razorpay.com/v1';
  static const String khaltiApi = 'https://khalti.com/api/v2';
  static const String esewaApi = 'https://uat.esewa.com.np';

  // Our Backend API (Firebase Functions)
  static const String backendBaseUrl =
      'https://us-central1-sahayak-ai.cloudfunctions.net';
  static const String chatApi = '$backendBaseUrl/chatCompletion';
  static const String paymentWebhook = '$backendBaseUrl/paymentWebhook';
  static const String documentApi = '$backendBaseUrl/processDocument';
  static const String userStatsApi = '$backendBaseUrl/getUserStats';

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Status Codes
  static const int success = 200;
  static const int created = 201;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int internalServerError = 500;
  static const int serviceUnavailable = 503;

  // Error Messages
  static const String timeoutError = 'Request timeout. Please try again.';
  static const String socketError = 'No internet connection.';
  static const String formatError = 'Invalid response format.';
  static const String cancelError = 'Request cancelled.';
}
