import 'package:injectable/injectable.dart';

import '../../../di/locator.dart';
import '../../../domain/use_case/settings_use_case.dart';
import '../../common/manager/theme_manager.dart';
import '../../common/services/settings_service.dart';
import '../../common/manager/view_manager.dart';

@injectable
class SettingsManager extends ViewManager {
  final SetSfxEnabledUseCase _setSfxEnabledUseCase =
      locator<SetSfxEnabledUseCase>();
  final SetSfxVolumeUseCase _setSfxVolumeUseCase =
      locator<SetSfxVolumeUseCase>();
  final SetMusicEnabledUseCase _setMusicEnabledUseCase =
      locator<SetMusicEnabledUseCase>();
  final SetMusicVolumeUseCase _setMusicVolumeUseCase =
      locator<SetMusicVolumeUseCase>();
  final SetThemeModeUseCase _setThemeModeUseCase =
      locator<SetThemeModeUseCase>();

  final SettingsService _settingsService = locator<SettingsService>();
  SettingsService get settingsService => _settingsService;

  final ThemeManager _themeManager = locator<ThemeManager>();
  ThemeManager get themeManager => _themeManager;

  // setters
  // Sound
  void setSfxEnabled(bool newValue) async {
    _settingsService.setSfxEnabled(newValue);
    await _setSfxEnabledUseCase.setSfxEnabled(newValue);
  }

  void setSfxVolume(double volume) async {
    _settingsService.setSfxVolume(volume);
    await _setSfxVolumeUseCase.setSfxVolume(volume);
  }

  void setMusicEnabled(bool newValue) async {
    _settingsService.setMusicEnabled(newValue);
    await _setMusicEnabledUseCase.setMusicEnabled(newValue);
  }

  void setMusicVolume(double volume) async {
    _settingsService.setMusicVolume(volume);
    await _setMusicVolumeUseCase.setMusicVolume(volume);
  }

  // Theme
  void setThemeMode(bool isDark) async {
    _themeManager.setThemeMode(isDark);
    await _setThemeModeUseCase.setThemeMode(isDark);
  }
}
