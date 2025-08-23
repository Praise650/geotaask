// theme_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'theme_preference';

  ThemeBloc() : super(const ThemeState(isDark: false)) {
    on<ToggleTheme>(_onToggleTheme);
    on<SetTheme>(_onSetTheme);

    // Load saved theme preference on initialization
    _loadTheme();
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    final newTheme = !state.isDark;
    emit(state.copyWith(isDark: newTheme));
    await _saveTheme(newTheme);
  }

  void _onSetTheme(SetTheme event, Emitter<ThemeState> emit) async {
    emit(state.copyWith(isDark: event.isDark));
    await _saveTheme(event.isDark);
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? false;
      add(SetTheme(isDark));
    } catch (e) {
      // Handle error - use default theme
      print('Error loading theme preference: $e');
    }
  }

  Future<void> _saveTheme(bool isDark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, isDark);
    } catch (e) {
      // Handle error
      print('Error saving theme preference: $e');
    }
  }
}