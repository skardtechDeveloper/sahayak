part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendMessage extends ChatEvent {
  final String message;
  final String language;

  const SendMessage({
    required this.message,
    required this.language,
  });

  @override
  List<Object> get props => [message, language];
}

class StartListening extends ChatEvent {}

class StopListening extends ChatEvent {}

class ClearChat extends ChatEvent {}

class ChangeLanguage extends ChatEvent {
  final String language;

  const ChangeLanguage(this.language);

  @override
  List<Object> get props => [language];
}
