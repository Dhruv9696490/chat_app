import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const _key = 'isChangedTheme';
  ThemeCubit() : super( const ThemeState(false)) {
    _initailTheme();
  }
  void changeTheme() async {
    final newTheme = !state.isDark;
    emit(ThemeState(newTheme));
    final ref = await SharedPreferences.getInstance();
    await ref.setBool(_key, newTheme);
  }

  void _initailTheme() async {
    final ref = await SharedPreferences.getInstance();
    emit(ThemeState(ref.getBool(_key) ?? false));
  }
}
