import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.light)) {
    on<ThemeChanged>(_onThemeChanged);
    on<ThemeLoaded>(_onThemeLoaded);
  }

  void _onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) {
    emit(state.copyWith(themeMode: event.themeMode));
  }

  void _onThemeLoaded(ThemeLoaded event, Emitter<ThemeState> emit) {
    // You can load theme from local storage here
    emit(state.copyWith(themeMode: ThemeMode.light));
  }
}
