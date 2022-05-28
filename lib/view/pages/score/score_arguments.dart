class ScoreArguments {
  final int _difficultyId;
  final int _score;
  final int _timeInSeconds;

  ScoreArguments(this._difficultyId, this._score, this._timeInSeconds);

  int get difficultyId => _difficultyId;

  int get score => _score;

  int get timeInSeconds => _timeInSeconds;
}
