
part of 'theme_bloc.dart';

// theme_event.dart
sealed class ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

class SetTheme extends ThemeEvent {
  final bool isDark;

  SetTheme(this.isDark);
}

// theme_state.dart
class ThemeState {
  final bool isDark;

  const ThemeState({required this.isDark});

  ThemeState copyWith({bool? isDark}) {
    return ThemeState(
      isDark: isDark ?? this.isDark,
    );
  }
}