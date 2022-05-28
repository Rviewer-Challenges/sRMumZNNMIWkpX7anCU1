abstract class SettingsRepository {
  // Sound
  Future<bool> getSfxEnabled();
  Future<bool> setSfxEnabled(bool isActivated);
  Future<double> getSfxVolume();
  Future<bool> setSfxVolume(double volume);
  Future<bool> getMusicEnabled();
  Future<bool> setMusicEnabled(bool isActivated);
  Future<double> getMusicVolume();
  Future<bool> setMusicVolume(double volume);

  // Theme
  Future<bool> getThemeMode();
  Future<bool> setThemeMode(bool isDark);
}
