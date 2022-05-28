abstract class TimeUtils {
  static String formatDuration(Duration remainedDuration) =>
      '${remainedDuration.inMinutes.remainder(60).toString().padLeft(2, '0')} : ${remainedDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
}
