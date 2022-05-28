import 'package:objectbox/objectbox.dart';

@Entity()
class Score {
  // Each "Entity" needs a unique integer ID property.
  int id = 0;

  @Index(type: IndexType.value)
  String name;
  int difficultyId;
  int score;
  int timeInSeconds;

  Score(this.name, this.difficultyId, this.score, this.timeInSeconds);

  Score setScore(int score) {
    this.score = score;

    return this;
  }

  Score setTime(int time) {
    timeInSeconds = time;

    return this;
  }
}
