import 'package:injectable/injectable.dart';

import '../../domain/repository/settings_repository.dart';
import '../datasource/shared_preferences/settings_preferences.dart';

@Injectable(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  // Sound
  @override
  Future<bool> getMusicEnabled() async =>
      await SettingsPreferences.musicEnabled;

  @override
  Future<double> getMusicVolume() async =>
      await SettingsPreferences.musicVolume;

  @override
  Future<bool> getSfxEnabled() async => await SettingsPreferences.sfxEnabled;

  @override
  Future<double> getSfxVolume() async => await SettingsPreferences.sfxVolume;

  @override
  Future<bool> setMusicEnabled(bool isActivated) async {
    await SettingsPreferences.setMusicEnabled(isActivated);

    return true;
  }

  @override
  Future<bool> setMusicVolume(double volume) async {
    await SettingsPreferences.setMusicVolume(volume);

    return true;
  }

  @override
  Future<bool> setSfxEnabled(bool isActivated) async {
    await SettingsPreferences.setSfxEnabled(isActivated);

    return true;
  }

  @override
  Future<bool> setSfxVolume(double volume) async {
    await SettingsPreferences.setSfxVolume(volume);

    return true;
  }

  // Theme
  @override
  Future<bool> getThemeMode() async => await SettingsPreferences.themeMode;

  @override
  Future<bool> setThemeMode(bool isDark) async {
    await SettingsPreferences.setThemeMode(isDark);

    return true;
  }
}
