part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool isListening;
  final String currentLanguage;

  const ChatState({
    this.messages = const [],
    this.isListening = false,
    this.currentLanguage = 'en',
  });

  @override
  List<Object> get props => [messages, isListening, currentLanguage];
}

class ChatInitial extends ChatState {
  const ChatInitial() : super();
}

class ChatLoading extends ChatState {
  const ChatLoading({
    required super.messages,
    required super.isListening,
    required super.currentLanguage,
  });
}

class ChatLoaded extends ChatState {
  const ChatLoaded({
    required super.messages,
    required super.isListening,
    required super.currentLanguage,
  });
}

class ChatError extends ChatState {
  final String error;

  const ChatError({
    required this.error,
    required super.messages,
    required super.isListening,
    required super.currentLanguage,
  });

  @override
  List<Object> get props => [error, ...super.props];
}
