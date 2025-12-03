class AppConstants {
  // App Information
  static const String appName = 'Sahayak AI Assistant';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // API URLs
  static const String baseUrl = 'https://api.sahayak.com';
  static const String openaiApiUrl = 'https://api.openai.com/v1';
  static const String nepaliDateApi = 'https://nepalicalendar.rat32.com/api/v1';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String chatsCollection = 'chats';
  static const String documentsCollection = 'documents';
  static const String paymentsCollection = 'payments';

  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String documentImagesPath = 'documents';
  static const String voiceNotesPath = 'voice_notes';

  // Language Codes
  static const String nepaliLanguageCode = 'ne';
  static const String englishLanguageCode = 'en';
  static const String hindiLanguageCode = 'hi';

  // Theme Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 4.0;

  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  // Chat Constants
  static const int maxChatHistory = 100;
  static const int maxTokensPerRequest = 1000;
  static const int typingIndicatorDuration = 1000; // milliseconds

  // Subscription Plans
  static const Map<String, dynamic> freePlan = {
    'name': 'Free',
    'price': 0,
    'currency': 'NPR',
    'chatsPerDay': 10,
    'documentsPerMonth': 5,
    'voiceMinutes': 30,
    'features': [
      'Basic AI Chat',
      'Limited Document Scan',
      'Standard Support',
    ],
  };

  static const Map<String, dynamic> premiumPlan = {
    'name': 'Premium',
    'price': 399,
    'currency': 'NPR',
    'chatsPerDay': 100,
    'documentsPerMonth': 50,
    'voiceMinutes': 300,
    'features': [
      'Unlimited AI Chats',
      'Advanced Document Scan',
      'Voice Assistant',
      'Priority Support',
    ],
  };

  static const Map<String, dynamic> proPlan = {
    'name': 'Professional',
    'price': 999,
    'currency': 'NPR',
    'chatsPerDay': 1000,
    'documentsPerMonth': 200,
    'voiceMinutes': 1000,
    'features': [
      'Everything in Premium',
      'Custom AI Models',
      'API Access',
      'Dedicated Support',
    ],
  };

  // Nepali Fonts
  static const String preetiFont = 'Preeti';
  static const String devanagariFont = 'NotoSansDevanagari';

  // Asset Paths
  static const String logoPath = 'assets/images/logo.png';
  static const String splashPath = 'assets/images/splash.png';
  static const String placeholderImage = 'assets/images/placeholder.png';

  // Local Storage Keys
  static const String userDataKey = 'user_data';
  static const String themeModeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String chatHistoryKey = 'chat_history';
  static const String settingsKey = 'app_settings';

  // Error Messages
  static const String networkError =
      'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String authError = 'Authentication failed. Please login again.';
  static const String unknownError = 'An unknown error occurred.';

  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String logoutSuccess = 'Logged out successfully!';
  static const String saveSuccess = 'Saved successfully!';
  static const String deleteSuccess = 'Deleted successfully!';

  // Validation Messages
  static const String emailRequired = 'Email is required';
  static const String validEmail = 'Please enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordLength = 'Password must be at least 6 characters';
  static const String nameRequired = 'Name is required';
  static const String phoneRequired = 'Phone number is required';
  static const String validPhone = 'Please enter a valid phone number';

  // Nepali Messages
  static const Map<String, String> nepaliMessages = {
    'welcome': 'सहायक AI मा स्वागत छ',
    'loading': 'लोड हुदैछ...',
    'error': 'त्रुटि भयो',
    'success': 'सफल भयो',
    'tryAgain': 'पुनः प्रयास गर्नुहोस्',
    'noInternet': 'इन्टरनेट जडान छैन',
    'emptyChat': 'कुनै च्याट छैन',
    'typeMessage': 'सन्देश लेख्नुहोस्...',
  };

  // Date Formats
  static const String nepaliDateFormat = 'yyyy-MM-dd';
  static const String displayDateFormat = 'dd MMM, yyyy';
  static const String timeFormat = 'hh:mm a';
  static const String dateTimeFormat = 'dd MMM, yyyy hh:mm a';

  // Ad Units (Test IDs)
  static const String admobAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const String bannerAdId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String rewardedAdId = 'ca-app-pub-3940256099942544/5224354917';
}
