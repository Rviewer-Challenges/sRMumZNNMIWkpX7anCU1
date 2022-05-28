import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../core/common/custom_notifiers.dart';
import '../../../core/common/play_dialog_types.dart';
import '../../../di/locator.dart';
import '../../common/services/audio_service.dart';
import '../../common/style/audio.dart';
import '../../utils/router.dart';
import '../../common/manager/view_manager.dart';
import '../score/score_arguments.dart';
import 'board_arguments.dart';
import 'models/card_model.dart';

@injectable
class BoardManager extends ViewManager {
  final AudioService _audioService = locator<AudioService>();

  final CustomValueNotifier<bool> _isInitialCountDown =
      CustomValueNotifier<bool>(true);
  CustomValueNotifier<bool> get isInitialCountDown => _isInitialCountDown;

  final CustomValueNotifier<Duration?> _remainedDuration =
      CustomValueNotifier<Duration?>(null);
  CustomValueNotifier<Duration?> get remainedDuration => _remainedDuration;

  bool _canSelect = false;
  bool get canSelect => _canSelect;

  int _points = 0;

  Timer? _timer;

  CardModel? _firstCardSelected;
  CardModel? _secondCardSelected;

  late BoardArguments _boardArguments;

  // setters
  void setCanSelect(bool can) => _canSelect = can;

  void _setFirstCardSelected(CardModel card) {
    _firstCardSelected = card.isFlipped ? null : card;
    card.flip();
  }

  void _setSecondCardSelected(CardModel card) {
    _canSelect = false;
    _secondCardSelected = card;
    card.flip();
  }

  // actions
  void startMusic(BoardArguments boardArguments) {
    _boardArguments = boardArguments;
    _audioService.playSong(boardArguments.gameConfiguration.music);
  }

  void startGame() {
    _isInitialCountDown.value = false;
    _canSelect = true;

    _remainedDuration.value = Duration(
      seconds: _boardArguments.gameConfiguration.timeInSeconds,
    );
    Future.delayed(
      const Duration(seconds: 1),
      () => _initTimer(),
    );
  }

  void _initTimer() => _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => _decreaseDuration(),
      );

  void _decreaseDuration() {
    final newDuration = _remainedDuration.value!.inSeconds - 1;
    _remainedDuration.value = Duration(seconds: newDuration);

    if (newDuration == 0) {
      _showLoseDialog();
      _timer!.cancel();
    }
  }

  void selectCard(CardModel card) => card.isFlipped
      ? _setFirstCardSelected(card)
      : (_firstCardSelected != null)
          ? _setSecondCardSelected(card)
          : _setFirstCardSelected(card);

  void checkPair() {
    if (_secondCardSelected != null) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () => (_firstCardSelected!.value == _secondCardSelected!.value)
            ? _pairFounded()
            : _restoreSelectedCards(),
      );
    }
  }

  void _pairFounded() {
    _firstCardSelected!.pairFounded();
    _secondCardSelected!.pairFounded();

    _points++;

    (_points == _boardArguments.gameConfiguration.pairsNumber)
        ? _gameWon()
        : _restoreSelectedCards();
  }

  void _gameWon() {
    _timer?.cancel();
    _canSelect = false;

    Future.delayed(
      const Duration(milliseconds: 300),
      (() => _showWinDialog()),
    );
  }

  void _restoreSelectedCards() {
    _firstCardSelected!.flip();
    _firstCardSelected = null;

    _secondCardSelected!.flip();
    _secondCardSelected = null;

    _canSelect = true;
  }

  void _resume() {
    navigationService.pop(); // Close dialog
    _audioService.resumeMusic();
    _initTimer();
  }

  void _retry() {
    _timer?.cancel();
    navigationService.pop(); // Close dialog
    navigationService.pushReplacement(AppRouter.boardRoute, _boardArguments);
  }

  // shows
  void _showWinDialog() async {
    _audioService.playSfx(Audio.win);
    _audioService.stopMusic();

    dialogService.showPlayDialog(PlayDialogType.win, [
      _navigateToScore,
      navigateToHome,
    ]);
  }

  void _showLoseDialog() async {
    _audioService.playSfx(Audio.lose);
    _audioService.stopMusic();
    _canSelect = false;

    dialogService.showPlayDialog(PlayDialogType.lose, [
      _retry,
      navigateToHome,
    ]);
  }

  Future<bool> showPauseDialog() async {
    _audioService.stopMusic();
    _timer?.cancel();

    dialogService.showPlayDialog(PlayDialogType.pause, [
      _resume,
      _navigateToSettings,
      navigateToHome,
    ]);

    return false;
  }

  // navigation
  @override
  void navigateToHome() {
    _timer?.cancel();
    _audioService.playSong(Audio.home1);

    super.navigateToHome();
  }

  void _navigateToSettings() =>
      navigationService.pushNamed(AppRouter.settingsRoute);

  void _navigateToScore() => navigationService.pushNamedWithArguments(
        AppRouter.scoreRoute,
        ScoreArguments(
          _boardArguments.difficultyId,
          _boardArguments.gameConfiguration.pairsNumber,
          _remainedDuration.value!.inSeconds,
        ),
      );

  @override
  void dispose() {
    _isInitialCountDown.dispose();
    _remainedDuration.dispose();

    super.dispose();
  }
}
