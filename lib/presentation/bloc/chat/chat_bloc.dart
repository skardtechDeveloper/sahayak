import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../domain/usecases/generate_ai_response.dart';
import '../../../../domain/usecases/save_chat_history.dart';
import '../../../../domain/entities/chat_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GenerateAIResponse generateAIResponse;
  final SaveChatHistory saveChatHistory;
  final SpeechToText speechToText;

  StreamSubscription<String>? _aiResponseStream;

  ChatBloc({
    required this.generateAIResponse,
    required this.saveChatHistory,
  })  : speechToText = SpeechToText(),
        super(ChatInitial()) {
    on<SendMessage>(_onSendMessage);
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
    on<ClearChat>(_onClearChat);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      // Add user message
      final userMessage = ChatMessage(
        text: event.message,
        isUser: true,
        timestamp: DateTime.now(),
        language: event.language,
      );

      emit(ChatLoaded(
        messages: [...state.messages, userMessage],
        isListening: state.isListening,
        currentLanguage: state.currentLanguage,
      ));

      // Generate AI response
      emit(ChatLoading(
        messages: state.messages,
        isListening: state.isListening,
        currentLanguage: state.currentLanguage,
      ));

      final aiResponse = await generateAIResponse(
        GenerateAIResponseParams(
          prompt: event.message,
          language: event.language,
          context: state.messages
              .skip(state.messages.length > 5 ? state.messages.length - 5 : 0)
              .map((m) => m.text)
              .toList(),
        ),
      );

      final aiMessage = ChatMessage(
        text: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
        language: event.language,
      );

      // Save to history
      await saveChatHistory(SaveChatHistoryParams(
        userMessage: userMessage,
        aiMessage: aiMessage,
      ));

      emit(ChatLoaded(
        messages: [...state.messages, aiMessage],
        isListening: state.isListening,
        currentLanguage: state.currentLanguage,
      ));
    } catch (e) {
      emit(ChatError(
        error: e.toString(),
        messages: state.messages,
        isListening: state.isListening,
        currentLanguage: state.currentLanguage,
      ));
    }
  }

  Future<void> _onStartListening(
    StartListening event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final isAvailable = await speechToText.initialize();

      if (isAvailable) {
        await speechToText.listen(
          onResult: (result) {
            if (result.finalResult) {
              add(SendMessage(
                message: result.recognizedWords,
                language: state.currentLanguage,
              ));
            }
          },
          listenFor: const Duration(seconds: 30),
          localeId: state.currentLanguage == 'ne' ? 'ne_NP' : 'en_US',
        );

        emit(ChatLoaded(
          messages: state.messages,
          isListening: true,
          currentLanguage: state.currentLanguage,
        ));
      }
    } catch (e) {
      emit(ChatError(
        error: 'Speech recognition failed: $e',
        messages: state.messages,
        isListening: false,
        currentLanguage: state.currentLanguage,
      ));
    }
  }

  Future<void> _onStopListening(
    StopListening event,
    Emitter<ChatState> emit,
  ) async {
    await speechToText.stop();
    emit(ChatLoaded(
      messages: state.messages,
      isListening: false,
      currentLanguage: state.currentLanguage,
    ));
  }

  void _onClearChat(ClearChat event, Emitter<ChatState> emit) {
    emit(ChatInitial());
  }

  void _onChangeLanguage(ChangeLanguage event, Emitter<ChatState> emit) {
    emit(ChatLoaded(
      messages: state.messages,
      isListening: state.isListening,
      currentLanguage: event.language,
    ));
  }

  @override
  Future<void> close() {
    _aiResponseStream?.cancel();
    speechToText.stop();
    return super.close();
  }
}
