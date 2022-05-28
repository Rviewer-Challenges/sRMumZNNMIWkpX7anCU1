import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/common/palette.dart';
import '../../../utils/game_utils/game_configuration.dart';
import '../models/card_model.dart';

class CustomCard extends StatefulWidget {
  const CustomCard(
    this._card,
    this._onCheckPair,
    this._isPairFounded,
    this._gameConfiguration, {
    Key? key,
  }) : super(key: key);

  final CardModel _card;
  final Function _onCheckPair;
  final bool _isPairFounded;
  final GameConfiguration _gameConfiguration;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    widget._card.init(this, widget._onCheckPair);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget._isPairFounded
        ? _EmptyCard(widget._card.backIcon)
        : AnimatedBuilder(
            animation: widget._card.animation!,
            builder: (_, __) => Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, .0015)
                ..rotateY(pi * widget._card.animation?.value),
              child: (widget._card.animation?.value <= .5)
                  ? _CardBack(widget._gameConfiguration.cardStyle)
                  : Transform(
                      alignment: FractionalOffset.center,
                      transform: Matrix4.identity()..setRotationY(pi),
                      child: _CardFront(widget._card.publicValue),
                    ),
            ),
          );
  }
}

class _CardFront extends StatelessWidget {
  const _CardFront(
    this._publicValue, {
    Key? key,
  }) : super(key: key);

  final String _publicValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Palette.black),
        borderRadius: BorderRadius.circular(8.0),
        color: Palette.cardFrontBackground,
        image: DecorationImage(
          image: AssetImage(_publicValue),
          alignment: Alignment.center,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack(this._cardStyle, {Key? key}) : super(key: key);

  final Gradient _cardStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Palette.black, width: 2),
        borderRadius: BorderRadius.circular(8.0),
        gradient: _cardStyle,
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard(this._icon, {Key? key}) : super(key: key);

  final String _icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Palette.black),
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: AssetImage(_icon),
          scale: .65,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
