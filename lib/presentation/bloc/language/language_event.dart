part of 'language_bloc.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class LanguageChanged extends LanguageEvent {
  final String languageCode;

  const LanguageChanged(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}

class LanguageLoaded extends LanguageEvent {}
