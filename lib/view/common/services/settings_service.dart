import 'package:injectable/injectable.dart';

import '../../../core/common/custom_notifiers.dart';
import '../../../di/locator.dart';
import '../../../domain/use_case/settings_use_case.dart';

@lazySingleton
class SettingsService {
  final GetSfxEnabledUseCase _getSfxEnabledUseCase =
      locator<GetSfxEnabledUseCase>();
  final GetSfxVolumeUseCase _getSfxVolumeUseCase =
      locator<GetSfxVolumeUseCase>();
  final GetMusicEnabledUseCase _getMusicEnabledUseCase =
      locator<GetMusicEnabledUseCase>();

  final CustomValueNotifier<bool> _isSfxEnabled =
      CustomValueNotifier<bool>(true);
  CustomValueNotifier<bool> get isSfxEnabled => _isSfxEnabled;

  final CustomValueNotifier<double> _sfxVolume =
      CustomValueNotifier<double>(.5);
  CustomValueNotifier<double> get sfxVolume => _sfxVolume;

  final CustomValueNotifier<bool> _isMusicEnabled =
      CustomValueNotifier<bool>(true);
  CustomValueNotifier<bool> get isMusicEnabled => _isMusicEnabled;

  final CustomValueNotifier<double> _musicVolume =
      CustomValueNotifier<double>(.5);
  CustomValueNotifier<double> get musicVolume => _musicVolume;

  // actions
  Future<void> init() async {
    isSfxEnabled.value = await _getSfxEnabledUseCase.getSfxEnabled();
    sfxVolume.value = (await _getSfxVolumeUseCase.getSfxVolume()).toDouble();
    isMusicEnabled.value = await _getMusicEnabledUseCase.getMusicEnabled();
  }

  // setters
  void setSfxEnabled(bool newValue) async => _isSfxEnabled.value = newValue;

  void setSfxVolume(double volume) async => _sfxVolume.value = volume;

  void setMusicEnabled(bool newValue) async => _isMusicEnabled.value = newValue;

  void setMusicVolume(double volume) async => _musicVolume.value = volume;

  void dispose() {
    _isSfxEnabled.dispose();
    _sfxVolume.dispose();
    _isMusicEnabled.dispose();
    _musicVolume.dispose();
  }
}
