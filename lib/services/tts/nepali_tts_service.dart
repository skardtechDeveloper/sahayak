import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';

enum TTSLanguage { nepali, english, hindi }

class NepaliTTSService {
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> initialize() async {
    // Configure TTS engine
    await _tts.setLanguage("ne-NP");
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    // Set up callbacks
    _tts.setStartHandler(() => debugPrint("TTS Started"));
    _tts.setCompletionHandler(() => debugPrint("TTS Completed"));
    _tts.setErrorHandler((msg) => debugPrint("TTS Error: $msg"));
  }

  Future<void> speak({
    required String text,
    required TTSLanguage language,
    String? voiceId,
  }) async {
    try {
      // Set language
      final langCode = _getLanguageCode(language);
      await _tts.setLanguage(langCode);

      // For Nepali, use special handling
      if (language == TTSLanguage.nepali) {
        await _speakNepali(text, voiceId);
      } else {
        await _tts.speak(text);
      }
    } catch (e) {
      debugPrint('TTS Error: $e');
      // Fallback to English
      await _tts.setLanguage("en-US");
      await _tts.speak(text);
    }
  }

  Future<void> _speakNepali(String text, String? voiceId) async {
    // Preprocess Nepali text for better pronunciation
    final processedText = _preprocessNepaliText(text);

    if (voiceId != null && voiceId.startsWith('premium_')) {
      // Use premium voice (pre-recorded or advanced TTS)
      await _playPremiumVoice(processedText, voiceId);
    } else {
      // Use default TTS
      await _tts.speak(processedText);
    }
  }

  String _preprocessNepaliText(String text) {
    // Fix common TTS pronunciation issues in Nepali
    return text
        .replaceAll('त्र', 'त र')
        .replaceAll('ज्ञ', 'ज ञ')
        .replaceAll('क्ष', 'क ष')
        .replaceAll('श्र', 'श र')
        .replaceAll('ऋ', 'रि')
        .replaceAll('ॠ', 'री');
  }

  Future<void> _playPremiumVoice(String text, String voiceId) async {
    // This would typically call a premium TTS API
    // For now, simulate with local audio files
    try {
      // Map voiceId to audio file
      final audioFile =
          'assets/sounds/voices/$voiceId/${text.hashCode % 10}.mp3';
      await _audioPlayer.setAsset(audioFile);
      await _audioPlayer.play();
    } catch (e) {
      // Fallback to default TTS
      await _tts.speak(text);
    }
  }

  String _getLanguageCode(TTSLanguage language) {
    switch (language) {
      case TTSLanguage.nepali:
        return "ne-NP";
      case TTSLanguage.english:
        return "en-US";
      case TTSLanguage.hindi:
        return "hi-IN";
    }
  }

  Future<void> stop() async {
    await _tts.stop();
    await _audioPlayer.stop();
  }

  Future<void> pause() async {
    await _tts.pause();
    await _audioPlayer.pause();
  }

  Future<void> setRate(double rate) async {
    await _tts.setSpeechRate(rate);
  }

  Future<void> setPitch(double pitch) async {
    await _tts.setPitch(pitch);
  }

  Future<List<dynamic>> getAvailableVoices() async {
    return await _tts.getVoices;
  }

  void dispose() {
    _tts.stop();
    _audioPlayer.dispose();
  }
}
