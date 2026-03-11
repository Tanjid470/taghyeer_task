import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _key = 'theme_mode';
  final SharedPreferences prefs;

  ThemeCubit(this.prefs) : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    final isDark = prefs.getBool(_key) ?? false;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    final isDark = state == ThemeMode.dark;
    await prefs.setBool(_key, !isDark);
    emit(isDark ? ThemeMode.light : ThemeMode.dark);
  }
}
