import 'dart:collection';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart' hide Logger;
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import '../../../core/common/custom_notifiers.dart';
import '../style/audio.dart';
import 'settings_service.dart';

class AudioService {
  static final _log = Logger('AudioController');

  late AudioCache _musicCache;

  late AudioCache _sfxCache;

  final AudioPlayer _musicPlayer;

  /// This is a list of [AudioPlayer] instances which are rotated to play
  /// sound effects.
  ///
  /// Normally, we would just call [AudioCache.play] and let it procure its
  /// own [AudioPlayer] every time. But this seems to lead to errors and
  /// bad performance on iOS devices.
  final List<AudioPlayer> _sfxPlayers;

  int _currentSfxPlayer = 0;

  final Queue<String> _playlist;

  final Random _random = Random();

  SettingsService? _settingsService;

  CustomValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  /// Creates an instance that plays music and sound.
  ///
  /// Use [polyphony] to configure the number of sound effects (SFX) that can
  /// play at the same time. A [polyphony] of `1` will always only play one
  /// sound (a new sound will stop the previous one). See discussion
  /// of [_sfxPlayers] to learn why this is the case.
  ///
  /// Background music does not count into the [polyphony] limit. Music will
  /// never be overridden by sound effects.
  AudioService({int polyphony = 2})
      : assert(polyphony >= 1),
        _musicPlayer = AudioPlayer(playerId: 'musicPlayer'),
        _sfxPlayers = Iterable.generate(
            polyphony,
            (i) => AudioPlayer(
                playerId: 'sfxPlayer#$i',
                mode: PlayerMode.LOW_LATENCY)).toList(growable: false),
        _playlist = Queue.of([Audio.home1]) {
    _musicCache = AudioCache(
      fixedPlayer: _musicPlayer,
      prefix: 'assets/sounds/music/',
    );
    _sfxCache = AudioCache(
      fixedPlayer: _sfxPlayers.first,
      prefix: 'assets/sounds/',
    );

    _musicPlayer.onPlayerCompletion.listen(_changeSong);
  }

  /// Enables the [AudioService] to listen to [AppLifecycleState] events,
  /// and therefore do things like stopping playback when the game
  /// goes into the background.
  void attachLifecycleNotifier(
      CustomValueNotifier<AppLifecycleState> lifecycleNotifier) {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);

    lifecycleNotifier.addListener(_handleAppLifecycle);
    _lifecycleNotifier = lifecycleNotifier;
  }

  /// Enables the [AudioService] to track changes to settings.
  /// Namely, when any of [SettingsService.isMusicEnabled],
  /// [SettingsService.sfxVolume] or [SettingsService.musicVolume] changes,
  /// the audio service will act accordingly.
  void attachSettings(SettingsService settingsService) {
    if (_settingsService == settingsService) {
      // Already attached to this instance. Nothing to do.
      return;
    }

    // Remove handlers from the old settings service if present
    final oldSettings = _settingsService;
    if (oldSettings != null) {
      oldSettings.isMusicEnabled.removeListener(_musicOnHandler);
      oldSettings.musicVolume.removeListener(_musicVolumeHandler);
      oldSettings.sfxVolume.removeListener(_sfxVolumeHandler);
    }

    _settingsService = settingsService;

    // Add handlers to the new settings service
    settingsService.isMusicEnabled.addListener(_musicOnHandler);
    settingsService.musicVolume.addListener(_musicVolumeHandler);
    settingsService.sfxVolume.addListener(_sfxVolumeHandler);

    if (settingsService.isMusicEnabled.value) {
      _startMusic();
    }
  }

  void dispose() {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);
    _stopAllSound();
    _musicPlayer.dispose();
    for (final player in _sfxPlayers) {
      player.dispose();
    }
    _settingsService?.dispose();
  }

  /// Preloads all sound effects.
  Future<void> initialize() async {
    _log.info('Preloading sound effects');
    // This assumes there is only a limited number of sound effects in the game.
    // If there are hundreds of long sound effect files, it's better
    // to be more selective when preloading.
    await _sfxCache.loadAll([Audio.win1, Audio.win2, Audio.lose1]);
  }

  /// Plays a single sound effect, called [sfx].
  ///
  /// The service will ignore this call when the attached settings'
  /// [SettingsService.isSfxEnabled] is `false`.
  void playSfx(List<String> sfxList) {
    final isSfxEnabled = _settingsService?.isSfxEnabled.value ?? true;

    if (!isSfxEnabled) {
      _log.info(
        () =>
            'Ignoring playing sound ($sfxList) because sounds are turned off.',
      );

      return;
    }

    String sfx = '';
    (sfxList.length > 1)
        ? sfx = sfxList[_random.nextInt(sfxList.length - 1)]
        : sfx = sfxList.first;

    _log.info(() => 'Playing sound: $sfx');
    _sfxCache.play(sfx);
    _currentSfxPlayer = (_currentSfxPlayer + 1) % _sfxPlayers.length;
    _sfxCache.fixedPlayer = _sfxPlayers[_currentSfxPlayer];
  }

  void playSong(String song) {
    if (_settingsService!.isMusicEnabled.value) {
      _log.info(() => 'Playing $song now.');
      _musicPlayer.stop();
      _musicCache.play(song);
    }
  }

  void _changeSong(void _) {
    _log.info('Last song finished playing.');
    // Put the song that just finished playing to the end of the playlist.
    _playlist.addLast(_playlist.removeFirst());
    // Play the next song.
    _log.info(() => 'Playing ${_playlist.first} now.');
    _musicCache.play(_playlist.first);
  }

  void _handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _stopAllSound();

        break;
      case AppLifecycleState.resumed:
        if (_settingsService!.isMusicEnabled.value) {
          _resumeMusic();
        }

        break;
      case AppLifecycleState.inactive:
        // No need to react to this state change.
        break;
    }
  }

  void _musicOnHandler() {
    if (_settingsService!.isMusicEnabled.value) {
      // Music got turned on.
      _startMusic();
    } else {
      // Music got turned off.
      stopMusic();
    }
  }

  void _musicVolumeHandler() {
    _musicPlayer.setVolume(_settingsService!.musicVolume.value);
  }

  void _sfxVolumeHandler() {
    for (final player in _sfxPlayers) {
      player.setVolume(_settingsService!.sfxVolume.value);
    }
  }

  Future<void> _resumeMusic() async {
    _log.info('Resuming music');
    switch (_musicPlayer.state) {
      case PlayerState.PAUSED:
        resumeMusic();
        break;
      case PlayerState.STOPPED:
        _log.info("resumeMusic() called when music is stopped. "
            "This probably means we haven't yet started the music. "
            "For example, the game was started with sound off.");
        await _musicCache.play(_playlist.first);
        break;
      case PlayerState.PLAYING:
        _log.warning('resumeMusic() called when music is playing. '
            'Nothing to do.');
        break;
      case PlayerState.COMPLETED:
        _log.warning('resumeMusic() called when music is completed. '
            "Music should never be 'completed' as it's either not playing "
            "or looping forever.");
        await _musicCache.play(_playlist.first);
        break;
    }
  }

  void _startMusic() {
    _log.info('starting music');
    _musicCache.play(
      _playlist.first,
      volume: _settingsService!.musicVolume.value,
    );
  }

  void resumeMusic() async {
    _log.info('Calling _musicPlayer.resume()');
    try {
      await _musicPlayer.resume();
    } catch (e) {
      // Sometimes, resuming fails with an "Unexpected" error.
      _log.severe(e);
      await _musicCache.play(_playlist.first);
    }
  }

  void _stopAllSound() {
    if (_musicPlayer.state == PlayerState.PLAYING) {
      _musicPlayer.pause();
    }
    for (final player in _sfxPlayers) {
      player.stop();
    }
  }

  void stopMusic() {
    _log.info('Stopping music');
    if (_musicPlayer.state == PlayerState.PLAYING) {
      _musicPlayer.pause();
    }
  }
}
