import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(
          ThemeState(
            themeData: ThemeData.light(),
            isDarkMode: false,
            isCustomFont: false,
            buttonColor: Colors.teal,
          ),
        ) {
    on<ToggleTheme>((event, emit) {
      emit(state.copyWith(
        isDarkMode: !state.isDarkMode,
        themeData: state.isDarkMode ? ThemeData.light() : ThemeData.dark(),
      ));
    });

    on<ToggleFont>((event, emit) {
      emit(state.copyWith(isCustomFont: !state.isCustomFont));
    });

    on<ChangeButtonColor>((event, emit) {
      emit(state.copyWith(
          buttonColor: state.buttonColor == Colors.teal
              ? Colors.green
              : Colors.teal));
    });
  }
}
