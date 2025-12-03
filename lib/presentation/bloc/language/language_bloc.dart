import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState(languageCode: 'en')) {
    on<LanguageChanged>(_onLanguageChanged);
    on<LanguageLoaded>(_onLanguageLoaded);
  }

  void _onLanguageChanged(LanguageChanged event, Emitter<LanguageState> emit) {
    emit(state.copyWith(languageCode: event.languageCode));
  }

  void _onLanguageLoaded(LanguageLoaded event, Emitter<LanguageState> emit) {
    // Load language from local storage
    emit(state.copyWith(languageCode: 'en'));
  }
}
