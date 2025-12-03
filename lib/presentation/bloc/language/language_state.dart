part of 'language_bloc.dart';

class LanguageState extends Equatable {
  final String languageCode;

  const LanguageState({required this.languageCode});

  LanguageState copyWith({
    String? languageCode,
  }) {
    return LanguageState(
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object> get props => [languageCode];
}
