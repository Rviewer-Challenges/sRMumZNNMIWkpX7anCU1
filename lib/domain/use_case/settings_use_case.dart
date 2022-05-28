// Sound
abstract class GetSfxEnabledUseCase {
  Future<bool> getSfxEnabled();
}

abstract class SetSfxEnabledUseCase {
  Future<bool> setSfxEnabled(bool isActivated);
}

abstract class GetSfxVolumeUseCase {
  Future<double> getSfxVolume();
}

abstract class SetSfxVolumeUseCase {
  Future<bool> setSfxVolume(double volume);
}

abstract class GetMusicEnabledUseCase {
  Future<bool> getMusicEnabled();
}

abstract class SetMusicEnabledUseCase {
  Future<bool> setMusicEnabled(bool isActivated);
}

abstract class GetMusicVolumeUseCase {
  Future<double> getMusicVolume();
}

abstract class SetMusicVolumeUseCase {
  Future<bool> setMusicVolume(double volume);
}

// Theme
abstract class GetThemeModeUseCase {
  Future<bool> getThemeMode();
}

abstract class SetThemeModeUseCase {
  Future<bool> setThemeMode(bool isDark);
}
