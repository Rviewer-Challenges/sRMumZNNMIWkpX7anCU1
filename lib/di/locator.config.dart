// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:flutter/material.dart' as _i6;
import 'package:flutter/widgets.dart' as _i10;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../core/services/dialog_service.dart' as _i5;
import '../core/services/navigation_service.dart' as _i9;
import '../data/repository/score_repository_impl.dart' as _i14;
import '../data/repository/settings_repository_impl.dart' as _i17;
import '../domain/repository/score_repository.dart' as _i13;
import '../domain/repository/settings_repository.dart' as _i16;
import '../domain/use_case/impl/score_use_case_impl.dart' as _i23;
import '../domain/use_case/impl/settings_repository_use_case_impl.dart' as _i21;
import '../domain/use_case/score_use_case.dart' as _i22;
import '../domain/use_case/settings_use_case.dart' as _i20;
import '../view/common/services/settings_service.dart' as _i18;
import '../view/pages/board/board_manager.dart' as _i3;
import '../view/pages/difficulty_mode/custom_mode/custom_mode_manager.dart'
    as _i4;
import '../view/pages/difficulty_mode/difficulty_mode_manager.dart' as _i7;
import '../view/pages/home/home_manager.dart' as _i8;
import '../view/pages/ranking/ranking_manager.dart' as _i11;
import '../view/pages/score/score_manager.dart' as _i12;
import '../view/pages/settings/settings_manager.dart' as _i15;
import '../view/pages/splash/splash_manager.dart'
    as _i19; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.BoardManager>(() => _i3.BoardManager());
  gh.factory<_i4.CustomModeManager>(() => _i4.CustomModeManager());
  gh.lazySingleton<_i5.DialogService>(
      () => _i5.DialogService(get<_i6.GlobalKey<_i6.NavigatorState>>()));
  gh.factory<_i7.DifficultyModeManager>(() => _i7.DifficultyModeManager());
  gh.factory<_i8.HomeManager>(() => _i8.HomeManager());
  gh.lazySingleton<_i9.NavigationService>(
      () => _i9.NavigationService(get<_i10.GlobalKey<_i10.NavigatorState>>()));
  gh.factory<_i11.RankingManager>(() => _i11.RankingManager());
  gh.factory<_i12.ScoreManager>(() => _i12.ScoreManager());
  gh.factory<_i13.ScoreRepository>(() => _i14.ScoreRepositoryImpl());
  gh.factory<_i15.SettingsManager>(() => _i15.SettingsManager());
  gh.factory<_i16.SettingsRepository>(() => _i17.SettingsRepositoryImpl());
  gh.lazySingleton<_i18.SettingsService>(() => _i18.SettingsService());
  gh.factory<_i19.SplashManager>(() => _i19.SplashManager());
  gh.factory<_i20.GetMusicEnabledUseCase>(
      () => _i21.GetMusicEnabledUseCaseImpl(get<_i16.SettingsRepository>()));
  gh.factory<_i20.GetMusicVolumeUseCase>(
      () => _i21.GetMusicVolumeUseCaseImpl(get<_i16.SettingsRepository>()));
  gh.factory<_i22.GetScoresUseCase>(
      () => _i23.GetScoreUseCaseImpl(get<_i13.ScoreRepository>()));
  gh.factory<_i20.GetSfxEnabledUseCase>(
      () => _i21.GetSfxEnabledUseCaseImpl(get<_i16.SettingsRepository>()));
  gh.factory<_i20.GetSfxVolumeUseCase>(
      () => _i21.GetSfxVolumeUseCaseImpl(get<_i16.SettingsRepository>()));
  gh.factory<_i20.GetThemeModeUseCase>(
      () => _i21.GetThemeModeUseCaseImpl(get<_i16.SettingsRepository>()));
  gh.factory<_i22.SaveScoreUseCase>(
      () => _i23.SaveScoreUseCaseImpl(get<_i13.ScoreRepository>()));
  gh.factory<_i20.SetMusicEnabledUseCase>(
      () => _i21.SetMusicEnabledUseCaseImpl(get<_i16.SettingsRepository>()));
  gh.factory<_i20.SetMusicVolumeUseCase>(
      () => _i21.SetMusicVolumeUseCaseImpl(get<_i16.SettingsRepository>()));
  gh.factory<_i20.SetSfxEnabledUseCase>(
      () => _i21.SetSfxEnabledUseCaseImpl(get<_i16.SettingsRepository>()));
  gh.factory<_i20.SetSfxVolumeUseCase>(
      () => _i21.SetSfxVolumeUseCaseImpl(get<_i16.SettingsRepository>()));
  gh.factory<_i20.SetThemeModeUseCase>(
      () => _i21.SetThemeModeUseCaseImpl(get<_i16.SettingsRepository>()));
  return get;
}
