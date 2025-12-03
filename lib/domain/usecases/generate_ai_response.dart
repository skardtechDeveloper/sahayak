class GenerateAIResponseParams {
  final String prompt;
  final String language;
  final List<String> context;
  final bool useOffline;

  GenerateAIResponseParams({
    required this.prompt,
    required this.language,
    this.context = const [],
    this.useOffline = false,
  });
}

class GenerateAIResponse {
  Future<String> call(GenerateAIResponseParams params) async {
    // This would call your AI service
    await Future.delayed(const Duration(seconds: 1));

    if (params.language == 'ne') {
      return 'म तपाईंको AI सहायक सहायक हुँ। तपाईंको प्रश्नको विश्लेषण गर्दैछु: "${params.prompt}"';
    } else {
      return 'I am your AI assistant Sahayak. I am analyzing your question: "${params.prompt}"';
    }
  }
}
