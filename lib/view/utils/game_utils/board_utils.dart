import 'package:found_pairs/view/common/style/pictures.dart';

import '../../pages/board/models/card_model.dart';

abstract class BoardUtils {
  static List<CardModel> generateDeck(int numPairs) {
    final _deck = <CardModel>[];

    for (int i = 0; i < numPairs; i++) {
      _deck.add(
        CardModel(
          i,
          Pictures.cardFrontPictures[i],
          Pictures.cardBackPictures[i],
        ),
      );
      _deck.add(
        CardModel(
          i,
          Pictures.cardFrontPictures[i],
          Pictures.cardBackPictures[i],
        ),
      );
    }
    _deck.shuffle();

    return _deck;
  }
}
