import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../di/locator.dart';
import '../../../core/common/palette.dart';
import '../../utils/game_utils/board_utils.dart';
import '../../utils/game_utils/game_configuration.dart';
import '../../utils/time_utils.dart';
import 'board_arguments.dart';
import 'board_manager.dart';
import 'models/card_model.dart';
import 'widgets/custom_card.dart';

class BoardPage extends StatefulWidget {
  const BoardPage(
    BoardArguments boardArguments, {
    Key? key,
  })  : _boardArguments = boardArguments,
        super(key: key);

  final BoardArguments _boardArguments;

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage>
    with SingleTickerProviderStateMixin {
  final BoardManager _manager = locator<BoardManager>();

  final List<CardModel> _deck = [];

  late AnimationController _initialCountDownController;
  late Animation _animation;

  @override
  void initState() {
    _deck.addAll(BoardUtils.generateDeck(
      widget._boardArguments.gameConfiguration.pairsNumber,
    ));

    _initialCountDownController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addStatusListener(_initialCountDownListener);
    _animation =
        Tween(begin: .0, end: 4.0).animate(_initialCountDownController);
    _manager.startMusic(widget._boardArguments);
    _initialCountDownController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _manager.dispose();
    _initialCountDownController.removeStatusListener(_initialCountDownListener);
    _initialCountDownController.dispose();

    for (CardModel card in _deck) {
      card.dispose();
    }

    super.dispose();
  }

  void _initialCountDownListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _manager.startGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _manager.showPauseDialog(),
      child: ValueListenableBuilder(
        valueListenable: _manager.isInitialCountDown,
        builder: (_, bool isInitialCountDown, __) => Scaffold(
          appBar: isInitialCountDown
              ? null
              : AppBar(
                  automaticallyImplyLeading: true,
                  title: _Timer(_manager),
                ),
          body: isInitialCountDown
              ? _AnimatedCountDown(_animation)
              : _Board(
                  _manager,
                  widget._boardArguments.gameConfiguration,
                  _deck,
                ),
        ),
      ),
    );
  }
}

class _AnimatedCountDown extends StatelessWidget {
  const _AnimatedCountDown(this.animation, {Key? key}) : super(key: key);

  final Animation animation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, __) => Opacity(
          opacity: animation.value - animation.value.toInt(),
          child: Text(
            _buildInitialCountDown(),
            style: TextStyle(
              fontSize: 64.sp,
              fontWeight: FontWeight.bold,
              color: Palette.red,
            ),
          ),
        ),
      ),
    );
  }

  String _buildInitialCountDown() {
    final intPart = 3 - animation.value.toInt();

    return (intPart <= 0) ? 'Catch all!' : intPart.toString();
  }
}

class _Timer extends StatelessWidget {
  const _Timer(
    BoardManager manager, {
    Key? key,
  })  : _manager = manager,
        super(key: key);

  final BoardManager _manager;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _manager.remainedDuration,
      builder: (_, Duration? remainedDuration, __) => Text(
        remainedDuration != null
            ? TimeUtils.formatDuration(remainedDuration)
            : '00:00',
        style: TextStyle(
          fontSize: 24.0.sp,
          fontWeight: FontWeight.w200,
          letterSpacing: 4.0,
        ),
      ),
    );
  }
}

class _Board extends StatelessWidget {
  const _Board(
    BoardManager manager,
    GameConfiguration gameConfiguration,
    List<CardModel> deck, {
    Key? key,
  })  : _manager = manager,
        _gameConfiguration = gameConfiguration,
        _deck = deck,
        super(key: key);

  final BoardManager _manager;
  final GameConfiguration _gameConfiguration;
  final List<CardModel> _deck;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Center(
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, .0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _gameConfiguration.cardColumns,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          childAspectRatio: size.aspectRatio * 1.8,
        ),
        itemCount: _deck.length,
        itemBuilder: (_, index) => _DeckItem(
          _manager,
          _gameConfiguration,
          _deck[index],
        ),
      ),
    );
  }
}

class _DeckItem extends StatelessWidget {
  const _DeckItem(
    BoardManager manager,
    GameConfiguration gameConfiguration,
    CardModel card, {
    Key? key,
  })  : _manager = manager,
        _gameConfiguration = gameConfiguration,
        _card = card,
        super(key: key);

  final BoardManager _manager;
  final GameConfiguration _gameConfiguration;
  final CardModel _card;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _card.isPairFounded,
      builder: (_, bool isPairFounded, __) => GestureDetector(
        onTap: () => _onItemTap(isPairFounded),
        child: CustomCard(
          _card,
          _manager.checkPair,
          isPairFounded,
          _gameConfiguration,
        ),
      ),
    );
  }

  void _onItemTap(bool isPairFounded) =>
      (isPairFounded || _card.isFlipped || !_manager.canSelect)
          ? null
          : _manager.selectCard(_card);
}
